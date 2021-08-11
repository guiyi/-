### 1.1 MySQL 数据库
### 1.2 SQL编程
### 1.3 数据库的应用类型
### 1.4 图形化的SQL查下分析器
### 1.5 小结




### 1.1 MySQL 数据库
#### 1.1.1 Mysql数据库历史
2010年12月 ，迎来了最重要的MySQL 5.5版本。
1. 半同步的复制
2. 对SIGNAL/RESIGNAL的异常处理功能的支持
3. InnoDB存储引擎变为默认存储引擎

* 初期开源数据库阶段
* 2008年1月 Sun MySQL阶段
* 2009年4月 Oracle Mysql阶段


#### 1.1.2 MySQL数据库的分支版本
* MariaDB
* Drizzle
* **InnoSQL**
> **InnoSQL**

* InnoDB Flash Cache 将SSD作为Flash Cache（之前版本的实现为SecondaryBuffer Pool）
* InnoDB Share Memory 将Share Memory作为InnoDB的共享内存，以此提高数据库的预热速度
* IO Statistics 扩展了MySQL原有Slow Log的内容，现在可记录某SQL语句的逻辑读取和物理读取的IO


### 1.2 SQL编程

* 第一阶段是面向过程化的SQL编程阶段。
* 第二阶段是面向集合的SQL编程阶段。
* 第三阶段是融合的SQL编程阶段。



### 1.3 数据库的应用类型

#### MySQL数据库的体系结构
* 连接池组件（Connection Pool）。

* 管理服务和工具组件（Management Services &Utilities）。

* SQL接口组件（SQL Interface）。

* 查询分析器组件（Parser）。

* 优化器组件（Optimizer）。

* 缓冲组件（Caches & Buffers）。

* 插件式存储引擎（Pluggable Storage Engines）。

* 物理文件（File system）。

  

  

  ![image-20210811172253205](/Users/adair/Library/Application Support/typora-user-images/image-20210811172253205.png)


**必须先要了解进行SQL编程的对象类型，即要开发的数据库应用是哪种类型.**
* **InnoDB** OLTP（OnLineTransaction Processing   ，联机事务处理）:面向基本的、日常的事务处理，例如银行交易.
* **MyISAM** OLAP（OnLine AnalysisProcessing ，联机分析处理）:数据仓库系统的主要应用，支持复杂的分析操作，侧重决策支持，并且提供直观易懂的查询结果.