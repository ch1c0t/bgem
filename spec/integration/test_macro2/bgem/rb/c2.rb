class_name, _colon, parent_name = name.partition ':'

head = unless parent_name.empty?
         "class #{class_name} < #{parent_name}\n"
       else
         "class #{class_name}\n"
       end

"#{head}#{body}end"
