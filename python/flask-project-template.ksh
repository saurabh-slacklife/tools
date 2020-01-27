#! /bin/ksh


create_dir() {
	dir_name=$1
	dir_path=$2

	mkdir -p ${dir_path}/${dir_name}/
	mkdir_status=$?

	if [ ${mkdir_status} -eq 0 ]; then
		echo "Directory created: ${dir_path}/${dir_name}/"
	else
		echo "Directory creation failed with exit status: ${mkdir_status}"
	fi
}

create_requirements() {
	file_path=$1
	req_dict=$2
	for elem in "${req_dict[@]}"; do
		echo "Name: ${elem} and value ${req_dict[$elem]}"
	done
}

create_minimal_req() {
	file_path=$1
	touch ${file_path}/requirements.txt

	file=${file_path}/requirements.txt
	echo "Flask==1.1.1" >> ${file}
	echo "redis==3.3.11" >> ${file}
	echo "requests==2.22.0" >> ${file}
	echo "flask-marshmallow==0.10.1" >> ${file}
	echo "Flask-RESTful==0.3.7" >> ${file}
	echo "coverage==4.5.3" >> ${file}
	echo "enum34==1.1.6" >> ${file}
}

add_dependencies() {
  dependency=$1
  version=$2
  file=$3
  if [[ -z "${version}" ]]; then
    echo "${dependency}" >> ${file}
  else
    echo "${dependency}==${version}" >> ${file}
  fi
}

create_specific_req() {
	file_path=$1
  file=${file_path}/requirements.txt

while true
	do
		printf "%s %s" "Enter the dependency name and version: "
		read dependency version
		echo "Dependency: ${dependency} and Version: ${version}"

		add_dependencies ${dependency} ${version} ${file}

		printf "%s" "Press Enter to continue and "n" or "N" to stop: "
		read answer
		case $answer in
			[nN]* )
				echo "Requirements complete"
				break;;
			* )
				continue
		esac 
	done  
}


create_default_dirs() {
	project_path=$1
	mkdir -p ${project_path}/app ${project_path}/app/main/ ${project_path}/app/main/common/ ${project_path}/app/main/dao/ ${project_path}/app/main/dto/ ${project_path}/app/main/model/ ${project_path}/app/main/resources/ ${project_path}/app/main/service/ ${project_path}/app/main/util/ ${project_path}/app/test/common/ ${project_path}/app/test/dao/ ${project_path}/app/test/dto/ ${project_path}/app/test/model/ ${project_path}/app/test/resources/ ${project_path}/app/main/test/service/ ${project_path}/app/test/main/util/ 
}


#################################################
# Main script starts here
#
# 
#
#
#
#################################################

printf "%s" "Enter the project name: "
read project_name
printf "%s" "Enter the directory path for project: "
read project_path

#create_default_dirs ${project_path}/${project_name}
mkdir -p ${project_path}/${project_name}


printf "%s" "Create minimal setup: y or n: "
read create_option 

case ${create_option} in
	[yY]* )
		echo "Creating project with minimal dependencies"
		create_minimal_req ${project_path}/${project_name}
		break;;
	[nN]* )
		echo "Please enter the required dependencies with versions you would like to install. If no version is specified, latest stable version will be installed."
		create_minimal_req ${project_path}/${project_name}
		create_specific_req ${project_path}/${project_name}
		break;;
	esac

