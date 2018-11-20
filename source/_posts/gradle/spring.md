# 使用gradle构建spring mvc web content

[toc]

##参考
* [官网](https://spring.io/guides/gs/serving-web-content/)
* [github](https://github.com/spring-guides/gs-serving-web-content/blob/master/initial/build.gradle)

##初始化构建
```
$ mkdir www.test.com
$ cd www.test.com
$ gradle init
$ vim build.gradle
buildscript {

    repositories {

        mavenCentral()

    }

    dependencies {

        classpath("org.springframework.boot:spring-boot-gradle-plugin:1.4.2.RELEASE")

    }

}



apply plugin: 'java'

apply plugin: 'eclipse'

apply plugin: 'idea'

apply plugin: 'spring-boot'



jar {

    baseName = 'gs-serving-web-content'

    version =  '0.1.0'

}



repositories {

    mavenCentral()

}



sourceCompatibility = 1.8

targetCompatibility = 1.8



dependencies {

    compile("org.springframework.boot:spring-boot-starter-thymeleaf")

    compile("org.springframework.boot:spring-boot-devtools")

    testCompile("junit:junit")

}
$ gradle idea
$ open www.test.com.ipr
```


