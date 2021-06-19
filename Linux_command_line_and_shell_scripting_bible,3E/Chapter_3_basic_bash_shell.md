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

