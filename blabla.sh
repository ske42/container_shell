#!/usr/bin/env bash
start_sh(){
  # get cid
  # return 0 if started shell
  # 2 if no container with same id
  docker exec -ti ${1} /bin/bash
  return 2
}

_get_cid_by_count(){
  # get  count:int
  # return cid:str
  # return 2 if no container count i
  cid=$(docker ps -q |sed -n ${1}p )
  [[ -z $cid ]] && echo 2
  echo ${cid}
}

err(){
  echo "There is no container was found to run a shell by given parametrs"
  echo "please choose one of below."
  docker ps -a --format "{{.ID}}: {{.Names}}: {{.Image}}: {{.Status}}"
  return
}

get_cid(){
  # get name:string or count:int
  #return container id:str
  [[ -z ${1} ]] && echo 2 && return
  [[ ${1} =~ ^[0-9]+$ ]] && echo $(_get_cid_by_count $1) && return
  cid=$(docker ps -f'id='${1}'' -q)
  [[ -n $cid ]] && echo ${cid} && return
  cid=$(docker ps -f'name='${1}'' -q)
  [[ -n $cid ]] && echo ${cid} && return
  echo 2
}

main(){
  cid=$(get_cid $1)
  [[ $cid == 2 ]] && err && return 2
  start_sh ${cid}

}
