# Git代码仓库迁移

一般来说，有时候我们需要将代码仓库由一个地址放到另外个地址托管。而已有的代码仓库可能会比较庞杂，有大量的本地分支、远程分支、TAG、Log、Stash等等，要想保留这些内容有2中方式。以下做简单学习记录。
* 修改远程仓库地址
* 直接迁移裸版本库
*前提：在新代码仓库建立空工程*

---

## 简易版

假设remote是origin，用git remote set_url 更换远程指向地址。
```Git
git remote set-url origin remote_git_address
```
把remote_git_address改为新的空仓库的git地址即可。
但是这样处理的话，新的Push提交时，要想保留所有信息的话需要挨个提交对应分支、TAG到新仓库，会比较麻烦。好处是不用重新改动工作目录，也可以保留stash记录、本地分支。如果简单的项目可以这样处理，也便于理解。但是复杂的项目就会显得繁琐。

---
## 改进版

直接从原仓库拷贝一份裸版本库到新仓库，并结合简单版的步骤，修改远程地址指向即可保留所有原工作区间的东西。
1. 添加--bare参数，克隆一份裸版本库。可以看到在当前目录下载了xxx_demo.git这个文件夹，里面内容只是没有工作目录，而是版本控制目录，这个目录就保存了你所有的仓库信息。

   ```
   git clone --bare git@gitlab.com:vito_kong/xxx_demo.git
   ```

   具体克隆的的三种方式的说明详见[传送门](http://ericyou.iteye.com/blog/1727540)

   > * `git clone origin-url` (non-bare) : you will get all of the tags copied, a local branch `master (HEAD)` tracking a remote branch `origin/master`, and remote branches `origin/next`,`origin/pu`, and `origin/maint`. The tracking branches are set up so that if you do something like `git fetch origin`, they'll be fetched as you expect. Any remote branches (in the cloned remote) and other refs are completely ignored.

   > * `git clone --bare origin-url` : you will get all of the tags copied, local branches `master (HEAD)`, `next`, `pu`, and `maint`, no remote tracking branches. That is, all branches are copied as is, and it's set up completely independent, with no expectation of fetching again. Any remote branches (in the cloned remote) and other refs are completely ignored.

   > * `git clone --mirror origin-url` : every last one of those refs will be copied as-is. You'll get all the tags, local branches `master (HEAD)`, `next`, `pu`, and `maint`, remote branches`devA/master` and `devB/master`, other refs `refs/foo/bar` and `refs/foo/baz`. Everything is exactly as it was in the cloned remote. Remote tracking is set up so that if you run `git remote update` all refs will be overwritten from origin, as if you'd just deleted the mirror and recloned it. As the docs originally said, it's a mirror. It's supposed to be a functionally identical copy, interchangeable with the original.

2. 进入到刚才下载的xxx_demo.git目录，并将其内内容以镜像的方式推送到新仓库，比如我这里的新仓库是Coding.net

   ```
   cd xxx_demo.git
   git push --mirror https://git.coding.net/antAtrom/xxx_demo_new.git
   ```

   然后这时候就可以在网页上看到新的仓库内已经包含了所有的工作空间和代码。
3. 这时候可以选择删除原有的本地仓库，新建目录并从新仓库clone代码下来。但是这样的话原有本地的暂存stash的修改记录就会没有了。所以可以结合简化版的方式，在原来的本地目录修改远程地址就可以无差完成代码托管仓库迁移
`git remote set-url origin remote_git_address` 