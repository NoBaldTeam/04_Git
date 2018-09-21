# Git指令集
是时候上这个图了。内容太宽泛，以下是常用指令。
![](http://pbdkyxc0r.bkt.clouddn.com/fec59e2c-3980-4ac6-8989-5f250ddf50f6.png)

## 编译操作相关

### git 配置相关指令

```
git config color.ui true   配置成彩色方式显示
git config --global color.ui true
git config --global color.ui auto
git config --global color.diff auto
git config --global color.branch auto
git config --global core.editor vim
git config --global alias.ct commit
git config --global alias.co checkout
git config --global alias.st status
git config --global alias.df diff
git config --global alias.br branch
git config --global merge.tool vimdiff
git config --global alias.logg "log --oneline --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ci) %C(bold blue)<%an>%Creset' --abbrev-commit"
```
git config --list     查看配置信息

###git Log相关
查看提交历史

```
git log {分支/commit_id/文件路径}
选项说明
-p 按补丁格式显示每个更新之间的差异。
--stat 显示每次更新的文件修改统计信息。
--shortstat 只显示--stat 中最后的行数修改添加移除统计。
--name-only 仅在提交信息后显示已修改的文件清单。
--name-status 显示新增、修改、删除的文件清单。
--abbrev-commit 仅显示SHA-1 的前几个字符，而非所有的40 个字符。
--relative-date 使用较短的相对时间显示（比如，“2 weeks ago”）。
--graph 显示ASCII 图形表示的分支合并历史。
--pretty 使用其他格式显示历史提交信息。可用的选项包括oneline，short，full，fuller 和format（后跟
指定格式）。
--follow 查看某个文件/路径的修改记录历史
```

###git Branch分支相关

###新建和切换分支###
```
git branch {branchname}  创建分支，如： git branch S501_PT_SDT
git checkout [branchname] 切换到该分支
git checkout -b [local-branch-name] 创建并切换，上两个命令的合并（默认从当前分支为镜像创建）
```

### 将两个commit之间的差异打包成zip文件
```
commitID  preCommitID
git diff  cc8d28e      0a16e58  --name-only  | xargs zip update.zip
```

**(需在alps同级目录使用此命令)**

### git Patch相关
### 生成Patch
#### git 标准方式
当前分支所有超前master的提交：
git format-patch -M master
某次提交以后的所有patch:
git format-patch 4e16 --4e16指的是commit名
从根到指定提交的所有patch:
git format-patch --root 4e16
某两次提交之间的所有patch:
git format-patch 365a..4e16 --365a和4e16分别对应两次提交的名称
某次提交（含）之前的几次提交：
git format-patch –n 07fe --n指patch数，07fe对应提交的名称
故，单次提交即为：
git format-patch -1 07fe
git format-patch生成的补丁文件默认从1开始顺序编号，并使用对应提交信息中的第一行作为文件名。如果使用了-- numbered-files选项，则文件名只有编号，不包含提交信息；如果指定了--stdout选项，可指定输出位置，如当所有patch输出到一个文件；可指定-o {dir}指定patch的存放目录；

### UNIX diff 方式

git diff 是生成标准patch
将当前修改未commit部分打包为patch,只含文件信息:
git diff > diff.patch 
git diff  > patch
git diff  --cached > patch
git diff  branchname --cached > patch

### 应用Patch

先检查patch文件：# git apply --stat newpatch.patch
检查能否应用成功：# git apply --check  newpatch.patch   *这个步骤就可以看出哪些文件会产生冲突*

打补丁：# git am --signoff < newpatch.patch 或git am newpatch.patch
(使用-s或--signoff选项，可以commit信息中加入Signed-off-by信息)

如果在前面check出的文件中有冲突，继续执行am该命令时产生Conflict时，am打patch的过程会到该文件进度中断，后续文件不会继续合下去

am失败时：
git am 并不改变index，am失败时需要使用 git apply --reject 打patch（保存在 .git/rebase-apply），手动解决代码冲突，（注：使用 git status 列出所有涉及文件），把所有文件（不仅仅是引起冲突的文件）添加到（git add）index，最后告诉 git am 你已经解决（--resolved）了问题。这样做的好处是你不需要重新编辑commit信息。而且，如果你正在打的是一系列patch（就是说你在打的是多个patch，比如 git am *.patch）你不需要使用 git am --abort，然后又 git am。

***
另应用**Google下发的Security Patch**时，由于它的patch针对的一般都是修改文件的父级目录而不是根目录，so：
patch -p1 < name.patch  该命令适用于生成的patch是不具备完整目录，需要将patch拷贝到对应根目录后才可打patch
*注：这种--reject的方法打patch的时候记录的是路径与修改，假如要打的工程没有这个目录则不会创建*

###git tag 相关
####打标签

给指定commit打标签
git tag -a v1.1 commitID

###发布标签
通常的git push不会将标签对象提交到git服务器，我们需要进行显式的操作：
git push origin v0.1.2 # 将v0.1.2标签提交到git服务器
git push origin --tags # 将本地所有标签一次性提交到git服务器
用git show命令可以查看标签的版本信息：
git show v0.1.2

###删除标签
误打或需要修改标签时，需要先将标签删除，再打新标签。
git tag -d v0.1.2 # 删除标签

###经验说

```
获得帮助信息
git help
git--help
man git-
检查当前文件状态
git status
查看当前远程仓库
git remote
添加远程仓库
git remote add [shortname] [url]
从远程仓库抓取数据，后remote-name可忽略则默认fetch所有
git fetch [remote-name]
从远程仓库抓取数据，After fetching, remove any remote-tracking branches which no longer exist on the remote.
git fetch -p 
推送数据到远程仓库remote-name一般为[origin remote_name]
git push <远程主机名> <本地分支名>:<远程分支名>
git push origin  [local-name]:[remote-name]
建立远程新分支同上，remote-name和local-name同名即可，远程无该名字将新建
git push [local-name]:[remote-name]
删除远程分支,push一个空分支上去，注意冒号前的空格
git push origin ：[remote-name]
查看远程仓库信息
git remote show [remote-name]
列出现有标签
git tag
在 git中对文件改名
git mv file_from file_to
重新提交
git commit --amend
取消暂存的文件
git checkout -- ...
查看已经暂存起来的文件和上次提交时的快照之间的差异
git diff --cached
git reset commitID        将commit回退到某个版本，但会将之前的提交、修改设为modify  状态
git reset --hard commitID 彻底回退到某个版本，本地的源码也会变为上一个版本的内容；
git reset --soft commitID 回退到某个版本，只撤销了commit，如果想再次提交，直接commit
git reset commitID --hard && git clean -fd 回退到某个版本，并删除掉untracked状态的目录
git stash 想切换分支，但是还不想提交你正在进行中的工作，则使用该命令储藏；
git stash list 查看现有储藏；
git stash apply 应用最近的储藏 apply 选项只尝试应用储藏的工作——储藏的内容仍然在栈上。要移除它，你可以运行 git stash drop，加上你希望移除的储藏的名字
git cherry-pick 7332bdf 将某一次提交更新到当前分支
git commit -a 提交所有更改
git clean -d -fx "" 出现error: The following untracked working tree files would be overwritten by checkout
git clone git@172.18.0.254:MT6582_L.git 下载源码到当前路径
$ grep -ir time
git format-patch -M branchName 生成补丁
git -rn "findname" *
git revert commitId 撤销某次提交的更改，并产生一条撤销的记录
推送到送程服务器(git push origin name:remote_name)
如：git push origin S501_PT_SDT:S501_PT_SDT
git pull 远程分支
git pull origin origin_branch:local_branch

git reflog 查看所有分支所有操作记录，包括被删除的记录，git log 不能查看已删除的记录。优势是可以读到所有分支的操作信息，得到已删除的commitId，可用于误删恢复、rebase恢复(因为rebase会重新生成commitId，原ID被删)等神器
```
