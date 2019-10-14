
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name LEDMatrix -dir "F:/ISE Projects/LEDMatrix/planAhead_run_3" -part xc6slx9tqg144-2
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "F:/ISE Projects/LEDMatrix/MatrixDriver.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {F:/ISE Projects/LEDMatrix} }
set_property target_constrs_file "MatrixDriver.ucf" [current_fileset -constrset]
add_files [list {MatrixDriver.ucf}] -fileset [get_property constrset [current_run]]
link_design
