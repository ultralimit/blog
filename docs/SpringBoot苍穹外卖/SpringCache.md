## 简介

> Spring Cache 基于注解的缓存功能

![image-20240611115133408](./assets/image-20240611115133408.png)

![image-20240611115228609](./assets/image-20240611115228609.png)

## 常用注解

![image-20240611115324064](./assets/image-20240611115324064.png)

## 入门案例

### 启动类加注解

![image-20240612085730761](./assets/image-20240612085730761.png)

### controller加注解

使用CachePut注解

![image-20240612212524056](./assets/image-20240612212524056.png)

![image-20240612212806763](./assets/image-20240612212806763.png)

使用Cacheable注解

![image-20240612213353058](./assets/image-20240612213353058.png)

> 先通过代理

使用CacheEvict注解

![image-20240612214239352](./assets/image-20240612214239352.png)

![image-20240612214247470](./assets/image-20240612214247470.png)

## 苍穹外卖案例

![image-20240612214650431](./assets/image-20240612214650431.png)

![image-20240612214717035](./assets/image-20240612214717035.png)

坐标

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-cache</artifactId>
</dependency>
```

启动类注解

![image-20240612214931512](./assets/image-20240612214931512.png)

controller注解

user的controller

![image-20240612220407778](./assets/image-20240612220407778.png)

admin的controller

![image-20240612220419094](./assets/image-20240612220419094.png)

> 注解的key的注释
>
> SpEL

![image-20240612220005608](./assets/image-20240612220005608.png)

