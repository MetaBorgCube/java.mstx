JAVA_FRONT   = lib/java.spfx/lang.java/
SUNSHINE_URL = http://artifacts.metaborg.org/service/local/repositories/releases/content/org/metaborg/org.metaborg.sunshine2/2.5.2/org.metaborg.sunshine2-2.5.2.jar
SUNSHINE_JAR = bin/org.metaborg.sunshine2-2.5.2.jar

MAVEN_OPTS = "-Xms512m -Xmx1024m -Xss16m"
MAVEN      = MAVEN_OPTS=$(MAVEN_OPTS) mvn
SUNSHINE   = java -jar 

PARSE_JAVA   = $(SUNSHINE) parse -l lib/java.spfx/lang.java -p . -i 

## Get depenencies

bin:
	mkdir -p bin

bin/org.metaborg.sunshine2-2.5.2.jar: bin
	curl $(SUNSHINE_URL) -o $(SUNSHINE_JAR)

sunshine: bin/org.metaborg.sunshine2-2.5.2.jar

lib/java.spfx/lang.java/target/lang.java-1.1.0-SNAPSHOT.spoofax-language:
	cd $(JAVA_FRONT) && $(MAVEN) verify

javafront: lib/java.spfx/lang.java/target/lang.java-1.1.0-SNAPSHOT.spoofax-language

## Testing

%.jav: %.java
	rename java jav $< 

%.aterm: %.jav sunshine
	$(PARSE_JAVA) $< > $@

test: javafront sunshine

## Building

## Cleaning

test-clean:
	find -iname "*.class" -exec rm {} \;
	find -iname "*.jav"   -exec rm {} \;
	find -iname "*.aterm" -exec rm {} \;
