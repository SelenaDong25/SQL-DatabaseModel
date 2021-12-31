use User_Computer_Management_Xin_Dong;
SELECT 
    u.user_name,
    u.user_information,
    c.computer_name,
    chu.permission_type,
    ov.os_version,
    ot.os_type,
    ug.user_group_name,
    ug.user_group_description,
    s.software_title,
    s.software_source,
    s.software_version
FROM
    user AS u
        left JOIN
    computer_has_user AS chu ON u.user_id = chu.user_id
        left JOIN
    computer AS c ON c.computer_name = chu.computer_name
        left JOIN
    os_version AS ov ON c.version_id = ov.version_id
       left JOIN
    os_type AS ot ON ov.type_id = ot.type_id
       left JOIN
    usergroup_has_user AS ughu ON u.user_id = ughu.user_id
       left JOIN
    usergroup AS ug ON ughu.user_group_name = ug.user_group_name
       left JOIN
    software AS s ON ug.software_id = s.software_id
    
    
 /*  Create JSON Object 
Users = {
            "user_name" : "John Doe",
            "user_information" : "room13",
            "computer_name" : "Computer1",
            "permission_type" : "Administrator",
            "os_version" : "Windows10",
            "os_type" : "Windows",
			"groups": [
			{
				"user_group_name" : "Group1",
				"user_group_description" : "User Group description 1 " 	
			},
			{
				"user_group_name" : "Group2",
				"user_group_description" : "User Group description 2 " 	
			}
			],
			"software": [
			{
			   "software_title" : "Software1",
			   "software_source" : "//share1/Software1",
			   "software_version" : "v.12"	
			},            
			{
			   "software_title" : "Software2",
			   "software_source" : "https://www.company.com/software2",
			   "software_version" : "v.1242"	
			}
			]
		}
*/