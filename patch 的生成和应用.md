## 什么是patch
Patch即被丁，是指两次修改之间的差异。在linux中，patch是由diff命令产生，本文专指git中的patch,由命令git format-patch产生。git的patch增加了一些附加信息，包括HASH值，作者，日期，注释，修改的文件列表和每一个文件修改的地方。
![](http://pbdkyxc0r.bkt.clouddn.com/wps4d8.tmp.jpg)

## 目的
为什么要用patch，因为省事，要在A项目上修改B项目上已改过的问题，传统办法是找到B项目修改过的代码，用比较工具修改A项目的代码。
写注释提交修改。
用patch的方式可以：
由A项目生成patch并分享出来。(分享者完成)
其它所以类似项目可直接应用此patch修改。
操作步骤
1.生成patch
2.git format-patch [HASHID] [-n] [-o dir]
3.HASHID使用git log时看到的每条记录的唯一ID，只需7位。默认为HEAD。commit ff206671ba4833260398e86fdebb725d2ea090c3 -n 指要生成patch,一条记录一个patch，默认将所以修改生成patch。[-o dir] 指定patch存放路径，默认放到当前目录。
 
## 应用patch
git am --rej patchName 
--rej 表示有冲突时生成冲突文件.rej,可用命令git status | grep .rej，查找冲突的地方。
patchName patch文件，也可用*，表示所有patch。
 
## 举例
我本地有s501bq和s500bq两个目录，将在s501bq上做patch，在s500bq目录上应用patch，具体操作如下图

![](http://pbdkyxc0r.bkt.clouddn.com/wps4d9.tmp.jpg)
 
具体修改项：9376213 - reopen voice control feature in camera

1.生成patch
命令：git format-patch 9376213 -1 -o ../../p
在../../p目录生成了patch文件
../../p/0001-reopen-voice-control-feature-in-camera.patch
 
2.应用补丁
命令: 
cd ../../s500bq/alps
git am –rej
 ../../p/0001-reopen-voice-control-feature-in-camera.patch
 
注意
有冲突时，解决完冲突后，要先用git add将修改过的文件加入暂存区，再用git status命令，确保修改过的文件
与patch中的修改文件一致。(patch文件中有文件修改列表，查关键字"files changed")
