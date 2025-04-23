from fabric import ThreadingGroup
import subprocess
import shlex
import argparse
import re
import os
from pathlib import Path

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-n', '--number', type=int, required=True, help='Docker Swarm Cluter Size')
    parser.add_argument('-a', '--ip', type=str, required=True, help='Mgr IP')
    parser.add_argument('-cn', '--client-number', type=int, required=True, help='Client Cluster Size')
    return parser.parse_args()

install_collectl = 'sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y collectl'
install_sysdig = 'sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y sysdig'
clone_official_socialnetwork_repo = 'ssh-keygen -F github.com || ssh-keyscan github.com >> ~/.ssh/known_hosts && git clone https://github.com/delimitrou/DeathStarBench.git && cd DeathStarBench && git checkout b2b7af9 && cd ..'
args = parse_args()

with ThreadingGroup(*[f'node-{idx}' for idx in range(args.number, args.number + args.client_number)]) as client_grp:
    client_grp[0].run(install_sysdig)
    client_grp.put(Path.home()/'.ssh/id_rsa', '.ssh')
    client_grp.run('if [ ! -e "$HOME/.ssh/config" ]; then echo -e "Host *\n\tStrictHostKeyChecking no" >> $HOME/.ssh/config; fi')
    client_grp.put(Path.home()/'RubbosClient.zip')
    client_grp.run('unzip RubbosClient.zip')
    client_grp.run('mv RubbosClient/elba .')
    client_grp.run('mv RubbosClient/rubbos .')
    client_grp.run('gcc $HOME/elba/rubbos/RUBBoS/bench/flush_cache.c -o $HOME/elba/rubbos/RUBBoS/bench/flush_cache')
    print('** RubbosClient copied **')

    os.chdir(Path.home())
    for file in ['src', 'RubbosClient_src', 'socialNetwork', 'scripts_limit', 'internal_triggers']:
        subprocess.run(shlex.split(f'unzip {file}.zip'))
    subprocess.run(shlex.split('mv DeathStarBench/socialNetwork/src DeathStarBench/socialNetwork/src.bk'))
    subprocess.run(shlex.split('mv src DeathStarBench/socialNetwork/'))

    os.chdir(Path.home())
    subprocess.run('mv socialNetwork/* DeathStarBench/socialNetwork/', shell=True)
    subprocess.run('mv socialNetwork/scripts/*.sh DeathStarBench/socialNetwork/scripts/', shell=True)
    subprocess.run(shlex.split('rm -r socialNetwork/scripts'))
    os.chdir(Path.home()/'DeathStarBench'/'socialNetwork')
    subprocess.run(shlex.split('sudo ./start.sh start'))
    print('** socialNetwork stack deployed **')

    os.chdir(Path.home()/'RubbosClient_src')
    subprocess.run(shlex.split('mvn clean'))
    subprocess.run(shlex.split('mvn package'))
    subprocess.run('./cpToCloud.sh')
    print('** client binary distributed **')

    # we move register here to ensure all the services have launched
    os.chdir(Path.home()/'DeathStarBench'/'wrk2')
    subprocess.run('make')
    subprocess.run(shlex.split('sudo apt-get -y install libssl-dev libz-dev luarocks'))
    subprocess.run(shlex.split('sudo luarocks install luasocket'))
    os.chdir(Path.home()/'DeathStarBench'/'socialNetwork')
    # TODO: check if socialNetwork is successfully deployed
    subprocess.run(shlex.split('./start.sh register'))
    subprocess.run(shlex.split('./start.sh compose'))
    print('** socialNetwork data created **')

    subprocess.run(shlex.split('sudo ./start.sh dedicate'))
    print('** core dedicated **\n** all the work is done, begin running the experiment **')