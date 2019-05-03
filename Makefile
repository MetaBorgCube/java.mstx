# paths
JAVA_FRONT   = lib/java.spfx/lang.java/
SUNSHINE_URL = http://artifacts.metaborg.org/service/local/repositories/releases/content/org/metaborg/org.metaborg.sunshine2/2.5.2/org.metaborg.sunshine2-2.5.2.jar
SUNSHINE_JAR = bin/org.metaborg.sunshine2-2.5.2.jar

## external commands with configuration
MAVEN_OPTS   = "-Xms512m -Xmx1024m -Xss16m"
MAVEN        = MAVEN_OPTS=$(MAVEN_OPTS) mvn
SUNSHINE     = java -jar $(SUNSHINE_JAR)
PARSE_JAVA   = $(SUNSHINE) parse -l lib/java.spfx/lang.java -p . -i 

TESTS       = tests/
JAVA_TESTS  = $(shell find $(TESTS) -name '*.java')
ATERM_TESTS = $(JAVA_TESTS:%.java=%.aterm)

## Default target

all: test

## Get depenencies

bin:
	mkdir -p bin

# get spoofax sunshine
bin/org.metaborg.sunshine2-2.5.2.jar: bin
	curl $(SUNSHINE_URL) -o $(SUNSHINE_JAR)

# ensure that spoofax sunshine is available
sunshine: bin/org.metaborg.sunshine2-2.5.2.jar

# compile the java frontend
lib/java.spfx/lang.java/target/lang.java-1.1.0-SNAPSHOT.spoofax-language:
	cd $(JAVA_FRONT) && $(MAVEN) verify

# ensure the java spoofax language frontend is compiled and available
javafront: lib/java.spfx/lang.java/target/lang.java-1.1.0-SNAPSHOT.spoofax-language sunshine

## Testing

%.jav: %.java
	cp $< $@

# Turn a jav file into its aterm representation
# using the Spoofax syntax definition
%.aterm: %.jav javafront
	$(PARSE_JAVA) $< > $@

%.javac: %.java
	javac $<

test: javafront $(ATERM_TESTS)

## Building

## Cleaning

test-clean:
	find -iname "*.class" -exec rm {} \;
	find -iname "*.jav"   -exec rm {} \;
	find -iname "*.aterm" -exec rm {} \;
