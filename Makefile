# paths
JAVA_FRONT   = lib/java.spfx/lang.java/
SUNSHINE_URL = http://artifacts.metaborg.org/service/local/repositories/releases/content/org/metaborg/org.metaborg.sunshine2/2.5.2/org.metaborg.sunshine2-2.5.2.jar
SUNSHINE_JAR = bin/org.metaborg.sunshine2-2.5.2.jar
SPEC         = src/java.mstx
TESTS        = tests/

## external commands with configuration
MAVEN_OPTS   = "-Xms512m -Xmx1024m -Xss16m"
MAVEN        = MAVEN_OPTS=$(MAVEN_OPTS) mvn
SUNSHINE     = java -jar $(SUNSHINE_JAR)
PARSE_JAVA   = $(SUNSHINE) parse -l lib/java.spfx/lang.java -p . -i 
STATIX       = statix $(SPEC)
JAVAC        = javac

JAVA_TESTS   = $(shell find $(TESTS) -name '*.java')

STX_TEST_TARGETS = $(JAVA_TESTS:%.java=%.stx.out)
JVC_TEST_TARGETS = $(JAVA_TESTS:%.java=%.javac.out)

.PHONY: all test
.PRECIOUS: %.aterm

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
javafront: lib/java.spfx/lang.java/ #target/lang.java-1.1.0-SNAPSHOT.spoofax-language sunshine

## Testing

# Turn a java file into its aterm representation
# using the Spoofax syntax definition
%.aterm: %.java
	cp $< $(<:%.java=%.jav)
	$(PARSE_JAVA) $(<:%.java=%.jav) > $@
	rm -f $(<:%.java=%.jav)

%.javac: %.java
	javac $<

%.stx.out: %.aterm
	$(STATIX) $< > $@ 2>&1 || true

%.javac.out: %.java
	$(JAVAC) $< &> $@ 2>&1 || true

test: $(STX_TEST_TARGETS) $(JVC_TEST_TARGETS)

## Building

## Cleaning

test-clean:
	find -iname "*.class" -exec rm {} \;
	find -iname "*.aterm" -exec rm {} \;
	find -iname "*.out"   -exec rm {} \;
