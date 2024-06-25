## 目录

![image-20240620200221386](./assets/image-20240620200221386.png) 

## 快速入门

![image-20240620200310470](./assets/image-20240620200310470.png) 

### 入门案例

#### (准备)导入数据库mp

![image-20240621094343613](./assets/image-20240621094343613.png) 

#### (准备)导入项目mp-demo

![image-20240621094608236](./assets/image-20240621094608236.png) 

#### 1. 引入MybatisPlus依赖

![image-20240621094648118](./assets/image-20240621094648118.png) 

```xml
<!--mybatis-plus依赖（包含mybatis）-->
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus-spring-boot3-starter</artifactId>
    <version>3.5.7</version>
</dependency>
```

```
注意SpringBoot的版本
```

![image-20240623100939980](./assets/image-20240623100939980.png)

#### 2. 自定义的Mapper继承MybatisPlus提供的BaseMapper接口

![image-20240621095457292](./assets/image-20240621095457292.png) 

> 增加	insert
> 删除        delete
> 修改	update
> 查询	select

![image-20240623101443413](./assets/image-20240623101443413.png)

### 常见注解

![image-20240623103424263](./assets/image-20240623103424263.png) 

**约定（大于配置）**

1. 类名转下划线作为表名
2. 变量名驼峰转下划线作为表的字段名
3. 名为id的字段作为主键

> 不符合约定，如何操作？

![image-20240623103710955](./assets/image-20240623103710955.png) 

![image-20240623104931296](./assets/image-20240623104931296.png)

![image-20240623104620005](./assets/image-20240623104620005.png) 

修改表名

![image-20240623105319295](./assets/image-20240623105319295.png) 

修改实体

![image-20240623111246529](./assets/image-20240623111246529.png) 

### 常见配置

![image-20240623111633817](./assets/image-20240623111633817.png) 

> 一般来说，只需要配置类型别名包

![image-20240623112823439](./assets/image-20240623112823439.png) 

## 核心功能

### 条件构造器

![image-20240623114218797](./assets/image-20240623114218797.png)

![image-20240623160609544](./assets/image-20240623160609544.png)

### 自定义SQL

![image-20240623161252138](./assets/image-20240623161252138.png) 

![image-20240623161619983](./assets/image-20240623161619983.png)

![image-20240623170957985](./assets/image-20240623170957985.png) 

![image-20240623172508895](./assets/image-20240623172508895.png)

### Service接口

![image-20240623182033409](./assets/image-20240623182033409.png) 

![image-20240623182119303](./assets/image-20240623182119303.png) 

[在线笔记地址](https://b11et3un53m.feishu.cn/wiki/PsyawI04ei2FQykqfcPcmd7Dnsc)

![image-20240623212418735](./assets/image-20240623212418735.png) 

### IService复杂查询

![image-20240624210205984](./assets/image-20240624210205984.png) 

```java
    @Override
    public List<User> queryUsers(String name, Integer status, Integer minBalance, Integer maxBalance) {
        return lambdaQuery()
                .like(name != null, User::getUsername, name)
                .eq(status != null, User::getStatus, status)
                .ge(minBalance != null, User::getBalance, minBalance)
                .le(maxBalance != null, User::getBalance, maxBalance)
                .list();
    }
```

### IService复杂修改

```java
    @Override
    @Transactional
    public void deductBalance(Long id, Integer money) {
        // 查询金额是否足够
        User user = this.getById(id);
        if (user == null || user.getStatus() == 2) {
            throw new RuntimeException("用户状态异常!");
        }
        if (user.getBalance() < money) {
            throw new RuntimeException("用户余额不足");
        }
        int remainMoney = user.getBalance() - money;
        // 扣减金额
        lambdaUpdate()
                .set(User::getBalance, remainMoney)
                .set(remainMoney == 0, User::getStatus, 2)
                .eq(User::getId, id)
                .eq(User::getBalance, user.getBalance())
                .update();
    }
```

### IService批量插入

```java
private User buildUser(int i) {
    User user = new User();
    user.setUsername("user_" + i);
    user.setPassword("123");
    user.setPhone("18688990011");
    user.setBalance(200);
    user.setInfo("{\"age\": 24, \"intro\": \"英文老师\", \"gender\": \"female\"}");
    user.setCreateTime(LocalDateTime.now());
    user.setUpdateTime(LocalDateTime.now());
    return user;
}

@Test
void testSaveOneByOne() {
    long b = System.currentTimeMillis();
    for (int i = 0; i < 100000; i++) {
        userService.save(buildUser(i));
    }
    long e = System.currentTimeMillis();
    System.out.println("耗时：" + (e - b));
}

@Test
void testSaveBatch() {
    List<User> list = new ArrayList<>(1000);
    long b = System.currentTimeMillis();
    for (int i = 0; i < 100000; i++) {
        list.add(buildUser(i));
        if (i % 1000 == 0) {
            userService.saveBatch(list);
            list.clear();
        }
    }
    long e = System.currentTimeMillis();
    System.out.println("耗时：" + (e - b));
}
```

![image-20240624214045684](./assets/image-20240624214045684.png) 

```
网络提交提高效率
SQL执行提高效率（MySQL）
```

配置文件添加后缀

```
&rewriteBatchedStatements=true
```

## 扩展功能

### 代码生成

> 二次元插件mybatisplus插件

### 静态工具

![image-20240624214952411](./assets/image-20240624214952411.png) 

```java
    @Override
    public UserVO queryUserAndAdressById(Long id) {
        // 查询用户
        User user = this.getById(id);
        if (user == null || user.getStatus() == 2) {
            throw new RuntimeException("用户状态异常");
        }
        // 查询地址
        List<Address> addressList = Db.lambdaQuery(Address.class)
                .eq(Address::getUserId, id).list();
        UserVO userVO = BeanUtil.copyProperties(user, UserVO.class);
        if(CollUtil.isNotEmpty(addressList)){
            userVO.setAddresses(BeanUtil.copyToList(addressList, AddressVO.class));
        }
        return userVO;
    }
```

### 逻辑删除

![image-20240624225117087](./assets/image-20240624225117087.png) 

![image-20240624225201734](./assets/image-20240624225201734.png)

```
可以采用数据迁移，然后真正删除.
```



### 枚举处理器



### JSON处理器



## 插件







