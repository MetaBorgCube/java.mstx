{-# LANGUAGE RecordWildCards #-}
import System.IO
import System.Exit
import System.Environment
import Control.Monad

import Development.Shake hiding ((*>))
import Development.Shake.Command
import Development.Shake.FilePath
import Development.Shake.Util

import Text.Parsec hiding (parseTest)
import Text.Parsec.Char
import Text.Regex.Base
import Text.Regex.TDFA

import Data.Text (Text, pack, unpack, strip)
import Data.String.AnsiEscapeCodes.Strip.Text

type TestPath = FilePath

build = "_build"

data Expect = ExpectOK | ExpectFail String deriving Show

data Test = Test
  { name   :: String
  , files  :: [(String, String)] -- filename , contents
  , javac  :: Expect
  , statix :: Expect
  } deriving (Show)

-- entrypoint

main = do
  [scriptDir, testFile] <- getArgs
  rules scriptDir testFile

-- Parser for test files

parseName  = many1 (satisfy $ \ c -> c /= ']')

discard :: Parsec Text u a -> Parsec Text u ()
discard p = do
  p
  return ()

header = do
  between (char '[') (char ']') parseName

parseFile = do
  filename <- spaces *> header
  let endOfFile = try $ lookAhead (discard header <|> eof)
  lines    <- manyTill (manyTill anyChar newline) endOfFile
  return (filename, unlines lines)

parseExpectation :: Parsec Text u Expect
parseExpectation =
      (try $ spaces >> string "ok" <* newline >> return ExpectOK)
  <|> (spaces >> ExpectFail <$> (string "fail" *> manyTill anyChar newline))

parseTest :: String -> Parsec Text u Test
parseTest name = do
  stxExp  <- string "STATIX" >> parseExpectation
  javExp  <- string "JAVAC"  >> parseExpectation

  files <- many1 parseFile
  eof

  return $ Test name files javExp stxExp

  where
    stripStr = unpack . strip . pack

-- auxiliary defs

checkJavaExpectation :: Expect -> ExitCode -> String -> Bool
checkJavaExpectation ExpectOK        code sout = code == ExitSuccess
checkJavaExpectation (ExpectFail er) code sout =
  case code of
    ExitSuccess      -> False
    ExitFailure erno -> sout =~ (".*" <> er <> ".*")

checkStxExpectation :: Expect -> ExitCode -> String -> Bool
checkStxExpectation ExpectOK        code sout = code == ExitSuccess
checkStxExpectation (ExpectFail er) code sout =
  case code of
    ExitSuccess      -> False
    ExitFailure erno -> sout =~ (".*" <> er <> ".*")

resultString :: Bool -> String
resultString ok = if ok then "SUCCESS" else "FAILURE"

-- rules

rules :: FilePath -> TestPath -> IO ()
rules scriptDir testPath = do

  -- some directories
  let specDir     = scriptDir </> ".." </> "src"
  let sunshine    = scriptDir </> ".." </> "bin/org.metaborg.sunshine2-2.5.11.jar"
  let langDir     = scriptDir </> ".." </> "lib/java.spfx/lang.java"
  let buildDir    = build </> testPath

  -- parse the test file
  txt      <- pack <$> readFile testPath
  Test{..} <- either (\err -> die $ "Couldn't parse test file: " ++ show err) return
    $ parse (parseTest testPath) testPath txt

  -- write the java files if they've changed
  forM_ files $ \(name, txt) -> do
    putStrLn $ "writing " ++ name
    writeFileChanged (buildDir </> name) txt

  shake shakeOptions{ shakeFiles = buildDir, shakeChange = ChangeDigest } $ do

    let javaFiles  = [ buildDir </> j                | (j, _) <- files ]
    let aterms     = [ buildDir </> (j -<.> "aterm") | (j, _) <- files ]
    let result     = buildDir </> "result"

    want [ result ]

    -- auxiliary file targets
    -------------------------

    "//*.jav" %> \out -> do
      let input = out -<.> "java"
      need [ input ]
      cmd_ "cp" input out

    "//*.aterm" %> \out -> do
      let jav = out -<.> "jav"
      need [ jav ]

      cmd_ "java -jar" sunshine
        "transform -n" [ "Explicate injections"] "-l"
        langDir "-p . -i" jav

    -- toplevel targets
    -------------------

    result %> \out -> do
      stxRes  <- readFile' $ buildDir </> "stx.result"
      javaRes <- readFile' $ buildDir </> "java.result"

      let res = stxRes == "SUCCESS" && javaRes == "SUCCESS"
      writeFile' out $ resultString res

    [ buildDir </> "java.out" , buildDir </> "java.result" ] &%> \[out, res] -> do
      -- Make sure to depend on the main input
      -- because Shake doesn't support dynamic dependencies
      need [ testPath ]
      need javaFiles

      -- run java on the inputs
      (Exit code, Stdouterr sout) <- withVerbosity Verbose $
                                       cmd "javac -d" buildDir javaFiles
      writeFileChanged out $ sout

      writeFile' res $ resultString (checkJavaExpectation javac code sout)

    [ buildDir </> "stx.out" , buildDir </> "stx.result" ] &%> \[out, res] -> do
      -- Make sure to depend on the main input
      need [ testPath ]
      need aterms

      -- depend on the entire spec
      getDirectoryFiles specDir ["//*.mstx"] >>= \mf -> do
        need [ specDir </> f | f <- mf ]

      -- run statix on all the aterms
      (Exit code, Stdouterr sout) <- withVerbosity Diagnostic $
                                      cmd "statix check -I" [specDir] "java" aterms
      let sout' = unpack $ stripAnsiEscapeCodes (pack sout)
      writeFileChanged out $ sout'

      writeFile' res $ resultString (checkStxExpectation statix code sout')
