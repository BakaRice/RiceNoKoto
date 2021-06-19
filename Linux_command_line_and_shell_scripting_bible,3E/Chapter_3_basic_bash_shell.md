> git push -u origin main  
> author: ricemarch at foxmail dot com
## 第三章 基本的bash shel命令

### 目录操作

1. `cd destination`:切换到指定目录  
   - `.`当前目录、`..`父级目录
2. `pwd`:显示当前会话目录
3. `ls`:按照字母排序列出文件
   - `-F`:区分文件和目录
   - `-R`:递归选项
   - `-l`:显示长列表
   - `-i`:查看文件或目录的inode编号
   - 使用过滤器：
        ```shell
        ls -l my_script
        ls -l my_scr?pt
        ls -l my*
        ls -l my_s*t
        ls -l my_scr[ai]pt
        ls -l my_scr[a-i]pt
        ls -l f[!a]il
        ```

### 处理文件

1. 创建文件   
```shell
touch test_one
ls -l test_one
# 如果只想改变修改时间，可以使用-a参数
touch -a test_one
# 查看文件的访问时间
ls -l --time=atime test_one
```
2. 复制文件
`cp source destination`  
当source和destination参数都是文件名时，cp命令将源文件复制成一个新文件，并且以destination命名。新文件就像全新的文件一样，有新的修改时间。
```shell
cp test_one test_two
# 如果test_two已经存在，则会强制覆盖，加上-i用于提示是否进行强制覆盖
cp -i test_one test_two
# cp命令的-R参数威力强大，可以用它在一条命令种递归地复制整个目录的内容
cp -R Scripts/ Mod_Scripts
# cp命令可种使用通配符
cp *script Mod_Scripts/
```

3. 制表键自动补全  
`tab`

4. 链接文件  
  在Linux种有两种不同的文件链接方式
   - 符号链接（软链接）
   - 硬链接
  
   ```shell
   ls -l data_file

   # 创建软连接 此时sl_data_file应该不存在
   ln -s data_file sl_data_file

   # 通过上述指令进行了创建，形成了一个新的符号 sl_data_file，故称之为符号链接
   # sl_data_file仅仅是指向data_file,他们的内容并不相同，是两个完全不同的文件
   -rw-r--r-- 1 root root    0 Jun 19 15:36 date_file
   lrwxrwxrwx 1 root root    9 Jun 19 15:36 sl_data_file -> date_file
   ```

   **硬链接**会创建独立的虚拟文件，其中包含了原始文件的信息及位置。但是他们从根本上而言是同一个文件。引用硬连接文件等同于引用了源文件。要创建硬链接，原始文件也必须事先存在。

   ```shell
   ls -l code_file
   # 硬链接 带有硬连接的文件共享inode编号，它们终归是一个文件，
   ln code_file hl_code_file
   ll -li *code_file
   2228532 -rw-r--r-- 2 root root 0 Jun 19 15:43 code_file
   2228532 -rw-r--r-- 2 root root 0 Jun 19 15:43 hl_code_file
   ```
   复制链接文件的时候一定要小心，如果使用cp命令复制一个文件，而该文件又已经被链接到了另一个源文件上，那么你得到的是源文件的一个副本，这很容易让人犯晕。用不着复制链接文件，可以创建原始文件的另一个链接。同一个文件拥有多个链接，这完全没问题。但，千万别创建软链接文件的软链接。这会造成混乱的链接链，不仅容易断裂，还会造成各种麻烦。

5. 重命名文件

6. 删除文件

### 处理目录