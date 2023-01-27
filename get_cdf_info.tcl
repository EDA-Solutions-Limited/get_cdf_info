
################################################################################
# Name: setup_users.py                                                         #
# Purpose: a function that grabs specific information from cells CDF properties#
#                                                                              #
# Release: 26/JAN/2023                                                         #
# Author: Henry Frankland @ EDA Solutions Ltd.                                 #
# Contact: Support@eda-solutions.com                                           #
#                                                                              #
# Please use this script at your own discretion and responsbility. Eventhough  #
# This script was tested and passed the QA criteria to meet the intended       #
# specifications and behaviors upon request, the user remains the primary      #
# responsible for the sanity of the results produced by the script.            #
# The user is always advised to check the imported design and make sure the    #
# correct data is present.                                                     #
#                                                                              #
# For further support or questions, please e-mail support@eda-solutions.com    #
#                                                                              #
# Test platform version: L-Edit/S-edit 2022.2 Update 2 Release build           #
################################################################################
# --------------------------
# Installation:- 
# --------------------------
# 1. for one time use drag and drop the script into S-edit command window,
# for persistent use copy the script into the 
# '%APPDATA%\Roaming\Tanner EDA\scripts\startup.sedit' folder
# --------------------------
# Usage:-
# --------------------------
# 1. adjust line 48 to the CDF properties you want to retreive
# 2. on line 74 replace "PUT_LIBRARY_NAME_HERE" with the name of the library you
# want to insepct the cdf properties of
# --------------------------
# Notes:
# --------------------------
# . this script is a demo script to demonstrate how you can leverage tcl to
# create a function that grabs specific CDF information from a library
################################################################################
#########################################################################
#                                                                       #
#   History:                                                            #
#   Version                                                             #
#           0.0 | 24/01/2023 - Script file first created                #
#           1.0 | 25/01/2023 - Script completed                         #
#########################################################################

proc get_all_cell_prop {lib} {
    ### build a list where each element of the list is another list containing a cell and its properties
    set list_of_cells_with_cdf {}
    set propertys_to_get {"m" "l" "w"}

    #grab a list of libraries that are open in the tools
    set all_designs [database designs]
    #gaurd clause, only continue if the selected library is in active project
    if {[lsearch $all_designs $lib] == -1} {puts "CRITICAL - did not find library $lib in open project"; exit}

    #get a list of all cells that are in the specified library
    set cell_list [database cells -library $lib]

    #foreach cell in library create a list containing {cell_name, property_N, property_N+1}
    foreach cell $cell_list {
        set cell_cdf_data [list $cell]
        foreach prop $propertys_to_get {
            #catch any errors generated when there are no matching CDF property. the output of cdf get returns a list of length 2, using lindex to get the value
            if {[catch {lappend cell_cdf_data [lindex [cdf get -library $lib -cell $cell -param $prop -defValue] 1]}]} {
                puts "ERROR invalid property value for $lib / $cell\:$prop"
            }
            
        }
        #append the cell and property list to the main list
        lappend list_of_cells_with_cdf $cell_cdf_data
    }
    return $list_of_cells_with_cdf
}

#run the function
set restults [get_all_cell_prop "PUT_LIBRARY_NAME_HERE"]

foreach result $restults {
    puts $result
}