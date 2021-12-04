#!/bin/sh

# http://hayne.net/MacDev/Notes/unixFAQ.html#shellStartup
# We require Bash but for portability we'd rather not use /bin/bash or
# /usr/bin/env in the shebang, hence this hack.
if [ "x$BASH_VERSION" = "x" ]
then
    exec bash "$0" "$@"
fi

PAS=$'[ \033[32;1mPASS\033[0m ] '
ERR=$'[ \033[31;1mFAIL\033[0m ] '
WAR=$'[ \033[33;1mWARN\033[0m ] '
INF="[ INFO ] "
# ------------------------------------------------------------------------------
#+UTILITIES

_err()
{ # All errors go to stderr.
    printf "[%s]: %s\n" "$(date +%s.%3N)" "$1"
}

_msg()
{ # Default message to stdout.
    printf "[%s]: %s\n" "$(date +%s.%3N)" "$1"
}

_debug()
{
    if [ "${DEBUG}" = '1' ]; then
        printf "[%s]: %s\n" "$(date +%s.%3N)" "$1"
    fi
}

# Return true if user answered yes, false otherwise.
# $1: The prompt question.
prompt_yes_no() {
    while true; do
        read -rp "$1" yn
        case $yn in
            [Yy]*) return 0;;
            [Nn]*) return 1;;
            *) _msg "Please answer yes or no."
        esac
    done
}

welcome()
{
    cat<<"EOF"

 _______________________  |  _ |_  _  _ _ _|_ _  _         
|O O O O O O O O O O O O| |_(_||_)(_)| (_| | (_)| \/       
|O O O O O O 1 O O O O O|                         /        
|O O O O O O O O O O O O|  /\    _|_ _  _ _  _ _|_. _  _   
|O O O O O O O O O O O O| /~~\|_| | (_)| | |(_| | |(_)| |  
|O O 1 O O O O O 1 O 1 O|  _                               
|O O O O O O O O O O O O| (  _ |   _|_. _  _  _            
|O O O 1 O O O O O O O O| _)(_)||_| | |(_)| |_)    
|O O O O O O O O O O O O|
 -----------------------  info@labsolns.com

This script installs LIMS*Nucleus on your system

http://www.labsolns.com

EOF
    echo -n "Press return to continue..."
    read -r
}

query()
{
    echo Enter IP address:
    read IPADDRESS
    
    echo Maximum number of plates per plate set:
    read MAXNUMPLATES
}


updatesys()
{

sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes update
sudo DEBIAN_FRONTEND=noninteractive apt-get  --assume-yes install gnupg git nscd postgresql-client
wget 'https://sv.gnu.org/people/viewgpg.php?user_id=15145' -qO - | sudo -i gpg --import -
wget 'https://sv.gnu.org/people/viewgpg.php?user_id=127547' -qO - | sudo -i gpg --import -
    
  
}

guixinstall()
{
    wget 'https://sv.gnu.org/people/viewgpg.php?user_id=15145' -qO - | sudo -i gpg --import -
    wget 'https://sv.gnu.org/people/viewgpg.php?user_id=127547' -qO - | sudo -i gpg --import -

    git clone --depth 1 https://github.com/mbcladwell/ln10.git 

    sudo ./ln10/guix-install-mod.sh

  ## using guile-3.0.2
    guix install glibc-utf8-locales guile-dbi
    sudo guix install glibc-utf8-locales
    export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"
             
    guix package --install-from-file=/home/admin/ln10/lnpg.scm

##    mkdir /home/admin/.configure
##    mkdir /home/admin/.configure/limsn
##    cp /home/admin/ln10/artanis.conf /home/admin/.configure/limsn

##    sudo sed -i "s/host.name = 127.0.0.1/host.name = $IPADDRESS/" /home/admin/.configure/limsn/artanis.conf
##    sudo sed -i "s/cookie.maxplates = 100/cookie.maxplates = $MAXNUMPLATES/"  /home/admin/.configure/limsn/artanis.conf

    
    source /home/admin/.guix-profile/etc/profile     
     export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"    


}

initdb()
{
    _msg "configuring db"

    ## note this must be in separate script:
##    /home/admin/ln10/install-lnpg.sh

#source /home/admin/.guix-profile/etc/profile 
 #   export LC_ALL="C"
    
  #  sudo chmod -R a=rwx /home/admin/ln10

#mkdir lndata

#echo "export PGDATA=\"/home/admin/lndata\"" >> /home/admin/.bashrc
#export PGDATA="/home/admin/lndata"

guile -e main -s labsolns.scm 127.0.0.1 5432 ln_admin welcome lndb init           

    
}





configure()
{

echo "export GUIX_PROFILE=\"/home/admin/.guix-profile\"" >> /home/admin/.bashrc
echo " . \"/home/admin/.guix-profile/etc/profile\"" >> /home/admin/.bashrc
echo "export LC_ALL=\"C\"" >> /home/admin/.bashrc
echo "export GUIX_LOCPATH=\"$HOME/.guix-profile/lib/locale\"" >> /home/admin/.bashrc


export GUIX_PROFILE="/home/admin/.guix-profile"
export LC_ALL="C"
export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale" 

    
}


main()
{
    local tmp_path
    export DEBIAN_FRONTEND=noninteractive 
    _msg "Starting installation ($(date))"
    
    updatesys
    configure
    installguix
    
   
    _msg "${INF}cleaning up ${tmp_path}"
   

    _msg "${PAS}LIMS*Nucleus has successfully been installed!"
    _msg "${PAS}Please exit and log back in to initialize environment variables."
    source /home/admin/.bashrc
    # Required to source /etc/profile in desktop environments.
     _msg "${INF}Run 'nohup ~/run-limsn.sh' to start the application server in detached mode."
 }

## https://www.ubuntubuzz.com/2021/04/lets-try-guix.html

main "$@"
