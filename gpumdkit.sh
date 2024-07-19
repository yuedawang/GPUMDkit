#!/bin/bash

# You need to set the path of GPUMD and GPUMDkit in your ~/.bashrc, for example
# export GPUMD_path=/d/Westlake/GPUMD/GPUMD
# export GPUMDkit_path=/d/Westlake/GPUMD/Gpumdkit

VERSION="0.0.0 (dev) (2024-07-19)"

function f1_format_conversion(){
echo " ------------>>"
echo " 101) Convert OUTCAR to extxyz"
echo " 102) Convert mtp to extxyz"
echo " 103) Convert cp2k to extxyz"
echo " 104) Convert castep to extxyz"
echo " 105) Convert extxyz to POSCAR"
echo " 106) Developing ... "
echo " 000) Return to the main menu"
echo " ------------>>"
echo " Input the function number:"

arry_num_choice=("000" "101" "102" "103" "104" ) 
read -p " " num_choice
while ! echo "${arry_num_choice[@]}" | grep -wq "$num_choice" 
do
  echo " ------------>>"
  echo " Please reinput function number..."
  read -p " " num_choice
done

case $num_choice in
    "101")
        echo " >-------------------------------------------------<"
        echo " | This function calls the script in GPUMD's tools |"
        echo " | Script: multipleFrames-outcars2nep-exyz.sh      |"
        echo " | Developer: Yanzhou WANG (yanzhowang@gmail.com ) |"
        echo " >-------------------------------------------------<"
        echo " Input the directory containing OUTCARs"
        echo " ------------>>"
        read -p " " dir_outcars
        echo " >-------------------------------------------------<"
        bash ${GPUMD_path}/tools/vasp2xyz/outcar2xyz/multipleFrames-outcars2nep-exyz.sh ${dir_outcars}
        echo " >-------------------------------------------------<"
        echo " Code path: ${GPUMD_path}/tools/vasp2xyz/outcar2xyz/multipleFrames-outcars2nep-exyz.sh"
        ;;
    "102")
        echo " >-------------------------------------------------<"
        echo " | This function calls the script in GPUMD's tools |"
        echo " | Script: mtp2xyz.py                              |"
        echo " | Developer: Ke XU (kickhsu@gmail.com)            |"
        echo " >-------------------------------------------------<"
        echo " Input <filename.cfg> <Symbol1 Symbol2 Symbol3 ...>"
        echo " Examp: train.cfg Pd Ag"
        echo " ------------>>"
        read -p " " mtp_variables
        echo " ---------------------------------------------------"
        python ${GPUMD_path}/tools/mtp2xyz/mtp2xyz.py ${mtp_variables}
        echo "Code path: ${GPUMD_path}/tools/mtp2xyz/mtp2xyz.py"
        echo " ---------------------------------------------------"
        ;;
    "103")
        echo " >-------------------------------------------------<"
        echo " | This function calls the script in GPUMD's tools |"
        echo " | Script: cp2k2xyz.py                             |"
        echo " | Developer: Ke XU (kickhsu@gmail.com)            |"
        echo " >-------------------------------------------------<"
        echo " Input <dir_cp2k> "
        echo " Examp: ./cp2k "
        echo " ------------>>"
        read -p " " dir_cp2k
        echo " ---------------------------------------------------"
        python ${GPUMD_path}/tools/cp2k2xyz/cp2k2xyz.py ${dir_cp2k}
        echo "Code path: ${GPUMD_path}/tools/cp2k2xyz/cp2k2xyz.py"
        echo " ---------------------------------------------------"
        ;;
    "104")
        echo " >-------------------------------------------------<"
        echo " | This function calls the script in GPUMD's tools |"
        echo " | Script: castep2nep-exyz.sh                      |"
        echo " | Developer: Yanzhou WANG (yanzhowang@gmail.com ) |"
        echo " >-------------------------------------------------<"
        echo " Input <dir_castep>"
        echo " Examp: ./castep "
        echo " ------------>>"
        read -p " " dir_castep
        echo " ---------------------------------------------------"
        bash ${GPUMD_path}/tools/castep2exyz/castep2nep-exyz.sh ${dir_castep}
        echo "Code path: ${GPUMD_path}/tools/castep2exyz/castep2nep-exyz.sh"
        echo " ---------------------------------------------------"
        ;;
    "105")
        echo " >-------------------------------------------------<"
        echo " | This function calls the script in Scripts       |"
        echo " | Script: exyz2pos.py                             |"
        echo " | Developer: Zihan YAN (yanzihan@westlake.edu.cn) |"
        echo " >-------------------------------------------------<"
        echo " Input the name of extxyz"
        echo " Examp: ./train.xyz "
        echo " ------------>>"
        read -p " " filename
        echo " ---------------------------------------------------"
        python ${GPUMDkit_path}/Scripts/format_conversion/exyz2pos.py ${filename}
        echo "Code path: ${GPUMDkit_path}/Scripts/format_conversion/exyz2pos.py"
        echo " ---------------------------------------------------"
        ;; 
    "106")
        echo " Developing ... "
        ;;
       
    "000")
        menu
        main
        ;;
esac

}

function f2_sample_structures(){
echo " ------------>>"
echo " 201) Sample structures from extxyz"
echo " 202) Find the outliers in training set"
echo " 203) Perturb structure"
echo " 204) Developing ... "
echo " 000) Return to the main menu"
echo " ------------>>"
echo " Input the function number:"

arry_num_choice=("000" "201" "202" "203" "204") 
read -p " " num_choice
while ! echo "${arry_num_choice[@]}" | grep -wq "$num_choice" 
do
  echo " ------------>>"
  echo " Please reinput function number..."
  read -p " " num_choice
done

case $num_choice in
    "201")
        echo " >-------------------------------------------------<"
        echo " | This function calls the script in Scripts       |"
        echo " | Script: sample_structures.py                    |"
        echo " | Developer: Zihan YAN (yanzihan@westlake.edu.cn) |"
        echo " >-------------------------------------------------<"
        echo " Input <extxyz_file> <sampling_method> <num_samples>"
        echo " Sampling_method: 'uniform' or 'random'"
        echo " Examp: train.xyz uniform 50 "
        echo " ------------>>"
        read -p " " sample_choice
        extxyz_file=$(echo ${sample_choice} | awk '{print $1}')
        sampling_method=$(echo ${sample_choice}| awk '{print $2}')
        num_samples=$(echo ${sample_choice}| awk '{print $3}')
        echo " ---------------------------------------------------"
        python ${GPUMDkit_path}/Scripts/sample_structures/sample_structures.py ${extxyz_file} ${sampling_method} ${num_samples}
        echo " Code path: ${GPUMDkit_path}/Scripts/sample_structures/sample_structures.py"
        echo " ---------------------------------------------------"
        ;;
    "202")
        echo " >-------------------------------------------------<"
        echo " | This function calls the script in GPUMD's tools |"
        echo " | Script: get_max_rmse_xyz.py                     |"
        echo " | Developer: Ke XU (kickhsu@gmail.com)            |"
        echo " >-------------------------------------------------<"
        echo " Input <extxyz_file> <*_train.out> <num_outliers>"
        echo " Examp: train.xyz energy_train.out 13 "
        echo " ------------>>"
        read -p " " maxrmse_choice
        echo " ---------------------------------------------------"
        python ${GPUMD_path}/tools/get_max_rmse_xyz/get_max_rmse_xyz.py ${maxrmse_choice}
        echo "Code path: ${GPUMD_path}/tools/get_max_rmse_xyz/get_max_rmse_xyz.py"
        echo " ---------------------------------------------------"
        ;;
    "203")
        echo " >-------------------------------------------------<"
        echo " | This function calls the script in Scripts       |"
        echo " | Script: perturb_structure.py                    |"
        echo " | Developer: Zihan YAN (yanzihan@westlake.edu.cn) |"
        echo " >-------------------------------------------------<"
        echo " Input <input.vasp> <pert_num> <cell_pert_fraction> <atom_pert_distance> <atom_pert_style>"
        echo " The default paramters for perturb are 20 0.03 0.2 normal"
        echo " Examp: FAPbI3.vasp 20 0.03 0.2 normal"
        echo " ------------>>"
        read -p " " perturb_choice
        echo " ---------------------------------------------------"
        python ${GPUMDkit_path}/Scripts/sample_structures/perturb_structure.py ${perturb_choice}
        echo "Code path: ${GPUMDkit_path}/Scripts/sample_structures/perturb_structure.py"
        echo " ---------------------------------------------------"
        ;;
    "204")
        echo " Developing ... "
        ;;
    "000")
        menu
        main
        ;;
esac

}

function f3_workflow_dev(){
echo " ------------>>"
echo " 301) SCF batch pretreatment"
echo " 302) MD sample batch pretreatment"
echo " 303) Developing ... "
echo " 000) Return to the main menu"
echo " ------------>>"
echo " Input the function number:"

arry_num_choice=("000" "301" "302" "303") 
read -p " " num_choice
while ! echo "${arry_num_choice[@]}" | grep -wq "$num_choice" 
do
  echo " ------------>>"
  echo " Please reinput function number..."
  read -p " " num_choice
done

case $num_choice in
    "301")
        source ${GPUMDkit_path}/Scripts/workflow/scf_batch_pretreatment.sh
        f301_scf_batch_pretreatment
        ;;
    "302")
        source ${GPUMDkit_path}/Scripts/workflow/md_sample_batch_pretreatment.sh
        f302_md_sample_batch_pretreatment
        ;;
    "303")
        echo " Developing ... "
        ;;        
    "000")
        menu
        main
        ;;
esac
}

#--------------------- main script ----------------------
# Show the menu
function menu(){
echo " ----------------------- GPUMD -----------------------"
echo " 1) Format Conversion          2) Sample Structures   "
echo " 3) Workflow (dev)             4) Developing ...      "
echo " 0) Quit!"
}

# Function main
function main(){
    echo " ------------>>"
    echo ' Input the function number:'
    array_choice=("0" "1" "2" "3" "4") 
    read -p " " choice
    while ! echo "${array_choice[@]}" | grep -wq "$choice" 
    do
      echo " ------------>>"
      echo " Please reinput function number:"
      read -p " " choice
    done

    case $choice in
        "0")
            echo " Thank you for using GPUMDkit. Have a great day!"
            exit 0
            ;;
        "1")
            f1_format_conversion
            ;;
        "2")
            f2_sample_structures
            ;;
        "3")
            f3_workflow_dev
            ;;
        "4")
            echo "Developing ..."
            ;;
        *)
            echo "Incorrect Options"
            ;;

    esac
    echo " Thank you for using GPUMDkit. Have a great day!"
}


######### Custom functional area ###############
function help_info(){
echo " GPUMDkit ${VERSION}"
echo " Usage: GPUMDkit -[options]"
echo " Options:
    -plt            Plot Scripts
                    Usage: -plt thermo/train/prediction [save]
                      Examp: gpumdkit.sh -plt thermo save

    -outcar2exyz    Convert OUTCAR to nep-exyz file
                    Usage: -outcar2exyz dir_name
                      Examp: gpumdkit.sh -outcar2exyz .

    -castep2exyz    Convert castep to nep-exyz file
                    Usage: -castep2exyz dir_name
                      Examp: gpumdkit.sh -castep2exyz .

    -cp2k2exyz      Convert cp2k output to nep-exyz file
                    Usage: -cp2k2exyz dir_name
                      Examp: gpumdkit.sh -cp2k2exyz .

    -max_rmse       get_max_rmse_xyz
                    Usage: -getmax|-get_max_rmse_xyz train.xyz force_train.out 13

    -min_dist       Get the minimum distance of any two atoms
                    Usage: -min_dist <exyzfile>

    -h,-help    Show this help message"
}

if [ ! -z "$1" ]; then
    case $1 in
        -h|-help)
            help_info
            ;;

        -plt)
            if [ ! -z "$2" ] ; then
                case $2 in
                    "thermo")
                        python ${GPUMDkit_path}/Scripts/plt_scripts/plt_nep_thermo.py $3
                        ;;
                    "train")
                        python ${GPUMDkit_path}/Scripts/plt_scripts/plt_nep_train_results.py $3
                        ;;  
                    "prediction")
                        python ${GPUMDkit_path}/Scripts/plt_scripts/plt_nep_prediction_results.py $3
                        ;;              
                    *)
                        echo "You need to specify a valid option"
                        echo "gpumdkit.sh -h for help information"
                        exit 1
                        ;;
                esac
            else
                echo "Missing argument"
                echo "Usage: -plt thermo/train/prediction (eg. gpumdkit.sh -plt thermo)"
                echo "See the codes in plt_scripts for more details"
                echo "Code path: ${GPUMDkit_path}/Scripts/plt_scripts"
            fi
            ;;

        -out2xyz|-outcar2exyz)
            if [ ! -z "$2" ]; then
                echo "Calling script by Yanzhou WANG et al. "
                echo "Code path: ${GPUMD_path}/tools/vasp2xyz/outcar2xyz/multipleFrames-outcars2nep-exyz.sh"
                bash ${GPUMD_path}/tools/vasp2xyz/outcar2xyz/multipleFrames-outcars2nep-exyz.sh $2
            else
                echo "Missing argument"
                echo "Usage: -out2xyz|-outcar2exyz dir_name (eg. gpumdkit.sh -outcar2exyz .)"
                echo "See the source code of multipleFrames-outcars2nep-exyz.sh for more details"
                echo "Code path: ${GPUMD_path}/tools/vasp2xyz/outcar2xyz/multipleFrames-outcars2nep-exyz.sh"
            fi
            ;;

        -cast2xyz|-castep2exyz)
            if [ ! -z "$2" ]; then
                echo "Calling script by Yanzhou WANG et al. "
                echo "Code path: ${GPUMD_path}/tools/castep2exyz/castep2nep-exyz.sh"
                bash ${GPUMD_path}/tools/castep2exyz/castep2nep-exyz.sh $2
            else
                echo "Missing argument"
                echo "Usage: -cast2xyz|-castep2exyz dir_name (eg. gpumdkit.sh -castep2exyz .)"
                echo "See the source code of castep2nep-exyz.sh for more details"
                echo "Code path: ${GPUMD_path}/tools/castep2exyz/castep2nep-exyz.sh"
            fi
            ;;

        -cp2k2xyz|-cp2k2exyz)
            if [ ! -z "$2" ]; then
                echo "Calling script by Ke XU et al. "
                echo "Code path: ${GPUMD_path}/tools/cp2k2xyz/cp2k2xyz.py"
                python ${GPUMD_path}/tools/cp2k2xyz/cp2k2xyz.py $2
            else
                echo "Missing argument"
                echo "Usage: -cp2k2xyz|-cp2k2exyz dir_name (eg. gpumdkit.sh -cp2k2exyz .)"
                echo "See the source code of cp2k2xyz.py for more details"
                echo "Code path: ${GPUMD_path}/tools/cp2k2xyz/cp2k2xyz.py"
            fi
            ;;

        -mtp2xyz|-mtp2exyz)
            if [ ! -z "$2" ]; then
                echo "Calling script by Ke XU et al. "
                echo "Code path: ${GPUMD_path}/tools/mtp2xyz/mtp2xyz.py"
                python ${GPUMD_path}/tools/mtp2xyz/mtp2xyz.py train.cfg $2 ${@:3}
            else
                echo "Missing argument"
                echo "Usage: -mtp2xyz|-mtp2exyz train.cfg Symbol1 Symbol2 Symbol3 ..."
                echo "  Examp: gpumdkit.sh -mtp2exyz train.cfg Pd Ag"
                echo "See the source code of mtp2xyz.py for more details"
                echo "Code path: ${GPUMD_path}/tools/mtp2xyz/mtp2xyz.py"
            fi
            ;;

        -max_rmse|-get_max_rmse_xyz)
            if [ ! -z "$2" ] && [ ! -z "$3" ] && [ ! -z "$4" ]; then
                echo "Calling script by Ke XU "
                echo "Code path: ${GPUMD_path}/tools/get_max_rmse_xyz/get_max_rmse_xyz.py"
                python ${GPUMD_path}/tools/get_max_rmse_xyz/get_max_rmse_xyz.py $2 $3 $4
            else
                echo "Missing argument"
                echo "Usage: -getmax|-get_max_rmse_xyz train.xyz force_train.out 13"
                echo "See the source code of get_max_rmse_xyz.py for more details"
                echo "Code path: ${GPUMD_path}/tools/get_max_rmse_xyz/get_max_rmse_xyz.py"
            fi
            ;;

        -min_dist)
            if [ ! -z "$2" ] ; then
                echo "Calling script by Zihan YAN "
                echo "Code path: ${GPUMDkit_path}/Scripts/sample_structures/get_min_dist.py"
                python ${GPUMDkit_path}/Scripts/sample_structures/get_min_dist.py $2
            else
                echo "Missing argument"
                echo "Usage: -min_dist <exyzfile>"
                echo "See the source code of get_min_dist.py for more details"
                echo "Code path: ${GPUMDkit_path}/Scripts/sample_structures/get_min_dist.py"
            fi
            ;;

        *)
            echo " Unknown option: $1 "
            help_info
            exit 1
            ;;
    esac
    exit
fi

## logo
echo -e "\
           ____ ____  _   _ __  __ ____  _    _ _   
          / ___|  _ \| | | |  \/  |  _ \| | _(_) |_ 
         | |  _| |_) | | | | |\/| | | | | |/ / | __|
         | |_| |  __/| |_| | |  | | |_| |   <| | |_ 
          \____|_|    \___/|_|  |_|____/|_|\_\_|\__|
                                            
          GPUMDkit Version ${VERSION}
        Developer: Zihan YAN (yanzihan@westlake.edu.cn)
      "
menu
main