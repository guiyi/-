SHOW COLUMNS FROM 数据表:
显示数据表的属性，属性类型，主键信息 ，是否为 NULL，默认值等其他信息。

SHOW INDEX FROM 数据表:
显示数据表的详细索引信息，包括PRIMARY KEY（主键）。


SHOW TABLE STATUS LIKE [FROM db_name] [LIKE 'pattern'] \G: 
该命令将输出Mysql数据库管理系统的性能及统计信息。
*************************** 31. row ***************************
           Name: user
         Engine: MyISAM
        Version: 10
     Row_format: Dynamic
           Rows: 2
 Avg_row_length: 126
    Data_length: 252
Max_data_length: 281474976710655
   Index_length: 4096
      Data_free: 0
 Auto_increment: NULL
    Create_time: 2016-11-26 15:22:26
    Update_time: 2017-03-02 10:06:01
     Check_time: NULL
      Collation: utf8_bin
       Checksum: NULL
 Create_options: 
        Comment: Users and global privileges
31 rows in set (0.00 sec)



MySQL存储引擎InnoDB与Myisam的六大区别
https://my.oschina.net/junn/blog/183341
