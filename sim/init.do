set project_name "npu_v2"

set rtl_files [glob rtl/*.v]
set tb_files [glob tb/*.sv]
 
if { [file exists "${project_name}.mpf"] } {
    puts "Project ${project_name} already exists, opening..."
    project open $project_name
    foreach rtl_d $rtl_files {project delete $rtl_d}
    foreach tb_d $tb_files {project delete $tb_d}
    foreach rtl $rtl_files {project addfile $rtl}
    foreach tb $tb_files {project addfile $tb}
    project compileall

} else {
    puts "Creating new project ${project_name}"
    project new . $project_name
    foreach rtl $rtl_files {project addfile $rtl}
    foreach tb $tb_files {project addfile $tb}
    project compileall
}

exit