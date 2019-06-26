# paths
JAVA_FRONT_DIR     =  lib/java.spfx/lang.java/
JAVA_FRONT_ARCHIVE = $(JAVA_FRONT)/target/lang.java-1.1.0-SNAPSHOT.spoofax-language
SPX_VERSION  = 2.6.0-SNAPSHOT
SUNSHINE_URL =  http://artifacts.metaborg.org/service/local/repositories/releases/content/org/metaborg/org.metaborg.sunshine2/$(SPX_VERSION)/org.metaborg.sunshine2-$(SPX_VERSION).jar
SUNSHINE_JAR =  bin/org.metaborg.sunshine2-$(SPX_VERSION).jar
SPEC         =  src/java.mstx
TESTS        ?= tests/ # directory
TESTRE       ?= '*' # iname

## external commands with configuration
MAVEN_OPTS   = "-Xms512m -Xmx1024m -Xss16m"
MAVEN        = MAVEN_OPTS=$(MAVEN_OPTS) mvn
SUNSHINE     = java -jar $(SUNSHINE_JAR)
PARSE_JAVA   = $(SUNSHINE) transform -n "Explicate injections" -l lib/java.spfx/lang.java -p . -i
STATIX       = statix $(SPEC)
JAVAC        = javac

JAVA_SOURCES = $(shell find $(TESTS) -type f -name $(TESTRE))
JAVA_TESTS   = $(shell find $(TESTS) -name $(TESTRE:%=%.java) -not -path "*/*.java/*")
TEST_TARGETS = $(JAVA_TESTS:%.java=%.result)

.PHONY: all test
.PRECIOUS: %.aterm

## Default target

all: test

## Get depenencies

bin:
	mkdir -p bin

# get spoofax sunshine
$(SUNSHINE_JAR): bin
	$(MAVEN) dependency:copy -DoutputDirectory=bin -Dartifact=org.metaborg:org.metaborg.sunshine2:$(SPX_VERSION) -Dmdep.useBaseVersion=true

# ensure that spoofax sunshine is available
sunshine: $(SUNSHINE_JAR)

# compile the java frontend
$(JAVA_FRONT_ARCHIVE): $(JAVA_FRONT_DIR)
	cd $(JAVA_FRONT_DIR) && $(MAVEN) verify

# ensure the java spoofax language frontend is compiled and available
javafront: $(JAVA_FRONT_ARCHIVE) sunshine

## Testing

# Turn a java file into its aterm representation
# using the Spoofax syntax definition
%.aterm: %.java
	cp $< $(<:%.java=%.jav)
	$(PARSE_JAVA) $(<:%.java=%.jav) > $@
	rm -f $(<:%.java=%.jav)

%.result: %.java src/
	@./tests/run $< | tee $@ | grep "FAILURE\|SUCCESS\|STUCK"

test: $(TEST_TARGETS)
test-results: 
	find . -name '*.result' -exec sh -c "cat {} | grep 'FAILURE\|SUCCESS\|STUCK'" \;

## Building

## Cleaning

test-clean:
	@find $(TESTS) -name "*.classes" -exec rm -rf {} \;
	@find $(TESTS) -name "*.aterm" -exec rm -f {} \;
	@find $(TESTS) -name "*.result" -exec rm -f {} \;
	@find $(TESTS) -name "*.out" -exec rm -f {} \;
