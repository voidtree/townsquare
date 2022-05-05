#!/bin/bash
npm run build
varHost='clocltower.voidtree.com'
varUser='root'
echo "\033[32m 打包文件 \033[32m"
echo "\033[37m --- \033[0m"
fileName="clocktower-${varUser}-`date +%Y%m%d%H%M%S`.tar.gz"
tar -zcvf "${fileName}" dist server
echo "打包成功，文件名为：$fileName"

echo "\033[32m 开始传送文件到：$varHost \033[32m"
echo "\033[37m --- \033[0m"
scp "${fileName}" "${varUser}@${varHost}:/usr/local/htdocs/clocktower/"

echo "\033[32m 传送完成，开始解压覆盖 \033[32m"
echo "\033[37m --- \033[0m"
ssh "${varUser}@${varHost}" "tar -xzvf /usr/local/htdocs/clocktower/${fileName} -C /usr/local/htdocs/clocktower"
ssh "${varUser}@${varHost}" "cd /usr/local/htdocs/clocktower; \cp -r dist/* .; rm -rf dist"
ssh "${varUser}@${varHost}" "cd /usr/local/htdocs/clocktower-server; mv ../clocktower/server/* .;pm2 startOrRestart /usr/local/htdocs/clocktower-server/pm2.config.js"

rm "${fileName}"

