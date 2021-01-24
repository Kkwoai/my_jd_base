#!/usr/bin/env bash

## Author: Evine Deng
## Source: https://github.com/EvineDeng/jd-base
## Modified： 2021-01-23
## Version： v3.5.4

## 路径、环境判断
ShellDir=${JD_DIR:-$(cd $(dirname $0); pwd)}
LogDir=${ShellDir}/log
[[ ${ANDROID_RUNTIME_ROOT}${ANDROID_ROOT} ]] && Opt="P" || Opt="E"
Tips="从日志中未找到任何互助码..."

## 所有有互助码的活动，只需要把脚本名称去掉前缀jd_后列在Name1中，将其中文名称列在Name2中即可。
## Name1和Name2中两个名称必须一一对应。
Name1=(fruit pet plantBean dreamFactory jdfactory crazy_joy jdzz jxnc bookshop cash immortal nh nian gyec xxl xxl_gh)
Name2=(东东农场 东东萌宠 京东种豆得豆 京喜工厂 东东工厂 crazyJoy任务 京东赚赚 京喜农场 口袋书店 签到领现金 神仙书院 年货节 炸年兽 工业品爱消除 东东爱消除 个护爱消除)

## 导出互助码的通用程序
function Cat_Scodes {
  if [ -d ${LogDir}/jd_$1 ] && [[ $(ls ${LogDir}/jd_$1) != "" ]]; then
    cd ${LogDir}/jd_$1
    for log in $(ls -r); do
      case $# in
        1)
          codes=$(cat ${log} | grep -${Opt} "开始【京东账号|您的(好友)?助力码为" | uniq | perl -0777 -pe "{s|\*||g; s|开始||g; s|\n您的(好友)?助力码为(：)?|：|g}" | perl -ne '{print if /：/}')
          ;;
        2)
          codes=$(grep -${Opt} $2 ${log} | perl -pe "{s| ||g; s|$2||g}")
          ;;
      esac
      [[ ${codes} ]] && break
    done
    [[ ${codes} ]] && echo ${codes} || echo ${Tips}
  else
    echo "还没有产生日志..."
  fi
}
## 导出炸年兽互助码
function Cat_ScodesNian {
  cd ${LogDir}/jd_nian
  for log in $(ls -r)
  do
    codes=$(perl -0777 -pe "s|\*+\n+||g" ${log} | grep -${Opt} "您的助力码为" | perl -pe "{s|\*+开始||g; s|您的助力码为|：|g}")
    [ -n "${codes}" ] && break
  done
  echo ${codes}
}
## 导出神仙书院互助码
function Cat_ScodesImmortal {
  cd ${LogDir}/jd_immortal
  for log in $(ls -r)
  do
    codes=$(perl -0777 -pe "s|\*+\n+||g" ${log} | grep -${Opt} "您的助力码为" | perl -pe "{s|\*+开始||g; s|您的助力码为|：|g}")
    [ -n "${codes}" ] && break
  done
  echo ${codes}
}

## 汇总
function Cat_All {
<<<<<<< HEAD
  echo -e "本脚本从最后一个正常的日志中寻找互助码，某些账号缺失则代表在最后一个正常的日志中没有找到。"
  echo -e "\n东东农场："
  Cat_Scodes fruit "的东东农场好友互助码" | perl -pe "s|的东东农场好友互助码||g"
  echo -e "\n东东萌宠："
  Cat_Scodes pet "的东东萌宠好友互助码" | perl -pe "s|的东东萌宠好友互助码||g"
  echo -e "\n种豆得豆："
  Cat_Scodes plantBean "的京东种豆得豆好友互助码" | perl -pe "s|的京东种豆得豆好友互助码||g"
  echo -e "\n京喜工厂："
  Cat_Scodes dreamFactory "的京喜工厂好友互助码" | perl -pe "s|的京喜工厂好友互助码||g"
  echo -e "\n东东工厂："
  Cat_Scodes jdfactory "的东东工厂好友互助码" | perl -pe "s|的东东工厂好友互助码||g"
  echo -e "\n疯狂的JOY："
  Cat_Scodes crazy_joy "的crazyJoy任务好友互助码" | perl -pe "s|的crazyJoy任务好友互助码||g"
  echo -e "\n京东赚赚："
  Cat_Scodes jdzz "的京东赚赚好友互助码" | perl -pe "s|的京东赚赚好友互助码||g"
  echo -e "\n京喜农场："
  Cat_Scodes jxnc "的京喜农场好友互助码" | perl -pe "s|的京喜农场好友互助码||g"
  echo -e "\n口袋书店："
  Cat_ScodesBookShop
  echo -e "\n签到领现金："
  Cat_ScodesCash
  echo -e "\n炸年兽："
  Cat_ScodesNian
  echo -e "\n神仙书院："
  Cat_ScodesImmortal
=======
  echo -e "\n本脚本从最后一个正常的日志中寻找互助码，某些账号缺失则代表在最后一个正常的日志中没有找到。"
  for ((i=0; i<${#Name1[*]}; i++)); do
    echo -e "\n${Name2[i]}："
    [[ $(Cat_Scodes "${Name1[i]}" "的${Name2[i]}好友互助码") == ${Tips} ]] && Cat_Scodes "${Name1[i]}" || Cat_Scodes "${Name1[i]}" "的${Name2[i]}好友互助码"
  done
>>>>>>> v3
}

## 执行并写入日志
LogTime=$(date "+%Y-%m-%d-%H-%M-%S")
LogFile="${LogDir}/export_sharecodes/${LogTime}.log"
[ ! -d "${LogDir}/export_sharecodes" ] && mkdir -p ${LogDir}/export_sharecodes
Cat_All | perl -pe "{s|京东种豆|种豆|; s|crazyJoy任务|疯狂的JOY|; s| |\n|g}" | tee ${LogFile}