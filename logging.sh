#!/bin/bash

exec &> >(sudo tee /var/log/june.log)
exec 2> >(sudo tee /var/log/june-error.log)
sudo cp $HOME/june.sh /var/log/june-script.log

# sudo tee -a /var/log/june.log <<'END'
cat <<'END'
         ,--.    ,----..                               
       ,--.'|   /   /   \                 ,---,        
   ,--,:  : |  /   .     :        ,---.  '  .' \       
,`--.'`|  ' : .   /   ;.  \      /__./| /  ;    '.     
|   :  :  | |.   ;   /  ` ; ,---.;  ; |:  :       \    
:   |   \ | :;   |  ; \ ; |/___/ \  | |:  |   /\   \   
|   : '  '; ||   :  | ; | '\   ;  \ ' ||  :  ' ;.   :  
'   ' ;.    ;.   |  ' ' ' : \   \  \: ||  |  ;/  \   \ 
|   | | \   |'   ;  \; /  |  ;   \  ' .'  :  | \  \ ,' 
'   : |  ; .' \   \  ',  /    \   \   '|  |  '  '--'   
|   | '`--'    ;   :    /      \   `  ;|  :  :         
'   : |         \   \ .'        :   \ ||  | ,'         
;   |.'          `---`           '---" `--''           
'---'                                                  


END
clear
