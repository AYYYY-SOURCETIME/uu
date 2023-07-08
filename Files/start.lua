Server_Done = io.popen("echo $SSH_CLIENT | awk '{ print $1}'"):read('*a')
redis = dofile("./libs/redis.lua").connect("127.0.0.1", 6379)
serpent = dofile("./libs/serpent.lua")
JSON    = dofile("./libs/dkjson.lua")
json    = dofile("./libs/JSON.lua")
URL     = dofile("./libs/url.lua")
http    = require("socket.http")
https   = require("ssl.https")
-------------------------------------------------------------------
whoami = io.popen("whoami"):read('*a'):gsub('[\n\r]+', '')
uptime=io.popen([[echo `uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"D,",h+0,"H,",m+0,"M."}'`]]):read('*a'):gsub('[\n\r]+', '')
CPUPer=io.popen([[echo `top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'`]]):read('*a'):gsub('[\n\r]+', '')
HardDisk=io.popen([[echo `df -lh | awk '{if ($6 == "/") { print $3"/"$2" ( "$5" )" }}'`]]):read('*a'):gsub('[\n\r]+', '')
linux_version=io.popen([[echo `lsb_release -ds`]]):read('*a'):gsub('[\n\r]+', '')
memUsedPrc=io.popen([[echo `free -m | awk 'NR==2{printf "%sMB/%sMB ( %.2f% )\n", $3,$2,$3*100/$2 }'`]]):read('*a'):gsub('[\n\r]+', '')
-------------------------------------------------------------------
Runbot = require('luatele')
-------------------------------------------------------------------
local infofile = io.open("./sudo.lua","r")
if not infofile then
if not redis:get(Server_Done.."token") then
os.execute('sudo rm -rf setup.lua')
io.write('\27[1;31mSend your Bot Token Now\n\27[0;39;49m')
local TokenBot = io.read()
if TokenBot and TokenBot:match('(%d+):(.*)') then
local url , res = https.request("https://api.telegram.org/bot"..TokenBot.."/getMe")
local Json_Info = JSON.decode(url)
if res ~= 200 then
print('\27[1;34mBot Token is Wrong\n')
else
io.write('\27[1;34mThe token been saved successfully \n\27[0;39;49m')
TheTokenBot = TokenBot:match("(%d+)")
os.execute('sudo rm -fr .infoBot/'..TheTokenBot)
redis:setex(Server_Done.."token",300,TokenBot)
end 
else
print('\27[1;34mToken not saved, try again')
end 
os.execute('lua5.3 start.lua')
end
if not redis:get(Server_Done.."id") then
io.write('\27[1;31mSend Developer ID\n\27[0;39;49m')
local UserId = io.read()
if UserId and UserId:match('%d+') then
io.write('\n\27[1;34mDeveloper ID saved \n\n\27[0;39;49m')
redis:setex(Server_Done.."id",300,UserId)
else
print('\n\27[1;34mDeveloper ID not saved\n')
end 
os.execute('lua5.3 start.lua')
end
local url , res = https.request('https://api.telegram.org/bot'..redis:get(Server_Done.."token")..'/getMe')
local Json_Info = JSON.decode(url)
local Inform = io.open("sudo.lua", 'w')
Inform:write([[
return {
	
Token = "]]..redis:get(Server_Done.."token")..[[",

id = ]]..redis:get(Server_Done.."id")..[[

}
]])
Inform:close()
local start = io.open("start", 'w')
start:write([[
cd $(cd $(dirname $0); pwd)
while(true) do
sudo lua5.3 start.lua
done
]])
start:close()
local Run = io.open("Run", 'w')
Run:write([[
cd $(cd $(dirname $0); pwd)
while(true) do
screen -S ]]..Json_Info.result.username..[[ -X kill
screen -S ]]..Json_Info.result.username..[[ ./start
done
]])
Run:close()
redis:del(Server_Done.."id")
redis:del(Server_Done.."token")
os.execute('cp -a ../u/ ../'..Json_Info.result.username..' && rm -fr ~/u')
os.execute('cd && cd '..Json_Info.result.username..';chmod +x start;chmod +x Run;./Run')
end
Information = dofile('./sudo.lua')
sudoid = Information.id
Token = Information.Token
bot_id = Token:match("(%d+)")
os.execute('sudo rm -fr .infoBot/'..bot_id)
bot = Runbot.set_config{
api_id=16097628,
api_hash='d21f327886534832fdf728117ac7b809',
session_name=bot_id,
token=Token
}
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
namebot = redis:get(bot_id..":namebot") or " تريكس"
SudosS = {1497373149}
Sudos = {sudoid,1497373149}
----------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
function coin(coin)
local Coins = tostring(coin)
local Coins = Coins:gsub('٠','0')
local Coins = Coins:gsub('١','1')
local Coins = Coins:gsub('٢','2')
local Coins = Coins:gsub('٣','3')
local Coins = Coins:gsub('٤','4')
local Coins = Coins:gsub('٥','5')
local Coins = Coins:gsub('٦','6')
local Coins = Coins:gsub('٧','7')
local Coins = Coins:gsub('٨','8')
local Coins = Coins:gsub('٩','9')
local Coins = Coins:gsub('-','')
local conis = tonumber(Coins)
return conis
end
function Bot(msg)  
local idbot = false  
if tonumber(msg.sender_id.user_id) == tonumber(bot_id) then  
idbot = true    
end  
return idbot  
end
function devS(user)  
local idSu = false  
for k,v in pairs(SudosS) do  
if tonumber(user) == tonumber(v) then  
idSu = true    
end
end  
return idSu  
end
function devB(user)  
local idSub = false  
for k,v in pairs(Sudos) do  
if tonumber(user) == tonumber(v) then  
idSub = true    
end
end  
return idSub
end
function Basic(msg) 
if msg and msg.chat_id and msg.sender_id.user_id then
if redis:sismember(bot_id..":Status:Basic",msg.sender_id.user_id) or devB(msg.sender_id.user_id) then    
return true  
else  
return false  
end  
end
end
function programmer(msg) 
if msg and msg.chat_id and msg.sender_id.user_id then
if redis:sismember(bot_id..":Status:programmer",msg.sender_id.user_id) or Basic(msg) then    
return true  
else  
return false  
end  
end
end
function developer(msg) 
if msg and msg.chat_id and msg.sender_id.user_id then
if redis:sismember(bot_id..":Status:developer",msg.sender_id.user_id) or programmer(msg) then    
return true  
else  
return false  
end  
end
end
function Creator(msg) 
if msg and msg.chat_id and msg.sender_id.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Creator", msg.sender_id.user_id) or developer(msg) then    
return true  
else  
return false  
end  
end
end
function BasicConstructor(msg) 
if msg and msg.chat_id and msg.sender_id.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:BasicConstructor", msg.sender_id.user_id) or Creator(msg) then    
return true  
else  
return false  
end  
end
end
function Constructor(msg) 
if msg and msg.chat_id and msg.sender_id.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Constructor", msg.sender_id.user_id) or BasicConstructor(msg) then    
return true  
else  
return false  
end  
end
end
function Owner(msg) 
if msg and msg.chat_id and msg.sender_id.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Owner", msg.sender_id.user_id) or Constructor(msg) then    
return true  
else  
return false  
end  
end
end
function Administrator(msg)
if msg and msg.chat_id and msg.sender_id.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Administrator", msg.sender_id.user_id) or Owner(msg) then    
return true  
else  
return false  
end  
end
end
function Vips(msg) 
if msg and msg.chat_id and msg.sender_id.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Vips", msg.sender_id.user_id) or Administrator(msg) or Bot(msg) then    
return true  
else  
return false  
end  
end
end
function Controllerbanall(user_id,chat_id)
if devS(user_id) then  
var = true
elseif devB(user_id) then 
var = true
elseif redis:sismember(bot_id..":Status:programmer", user_id) then
var = true
elseif tonumber(user_id) == tonumber(bot_id) then  
var = true
elseif redis:sismember(bot_id..":Status:developer", user_id) then
var = true
elseif redis:sismember(bot_id..":"..chat_id..":Status:Creator", user_id) then
var = true
elseif redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Constructor", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Owner", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Administrator", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Vips", user_id) then
var = false
else  
var = false
end  
return var
end 

function Get_Rank(user_id,chat_id)
if devS(user_id) then  
var = 'مطور السورس'
elseif devB(user_id) then 
var = "المطور الاساسي"  
elseif redis:sismember(bot_id..":Status:Basic", user_id) then
var = "المطور الاساسي²"  
elseif redis:sismember(bot_id..":Status:programmer", user_id) then
var = "المطور الثانوي"  
elseif tonumber(user_id) == tonumber(bot_id) then  
var = "البوت"
elseif redis:sismember(bot_id..":Status:developer", user_id) then
var = redis:get(bot_id..':SetRt'..chat_id..':'..user_id) or redis:get(bot_id..":Reply:developer"..chat_id) or "المطور"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Creator", user_id) then
var = redis:get(bot_id..':SetRt'..chat_id..':'..user_id) or redis:get(bot_id..":Reply:Creator"..chat_id) or "المالك"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor", user_id) then
var = redis:get(bot_id..':SetRt'..chat_id..':'..user_id) or redis:get(bot_id..":Reply:BasicConstructor"..chat_id) or "المنشئ الاساسي"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Constructor", user_id) then
var = redis:get(bot_id..':SetRt'..chat_id..':'..user_id) or redis:get(bot_id..":Reply:Constructor"..chat_id) or "المنشئ"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Owner", user_id) then
var = redis:get(bot_id..':SetRt'..chat_id..':'..user_id) or redis:get(bot_id..":Reply:Owner"..chat_id)  or "المدير"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Administrator", user_id) then
var = redis:get(bot_id..':SetRt'..chat_id..':'..user_id) or redis:get(bot_id..":Reply:Administrator"..chat_id) or "الادمن"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Vips", user_id) then
var = redis:get(bot_id..':SetRt'..chat_id..':'..user_id) or redis:get(bot_id..":Reply:Vips"..chat_id) or "مميز"  
else  
var = redis:get(bot_id..':SetRt'..chat_id..':'..user_id) or redis:get(bot_id..":Reply:mem"..chat_id) or "عضو"
end  
return var
end 
function Norank(user_id,chat_id)
if devS(user_id) then  
var = false
elseif devB(user_id) then 
var = false
elseif redis:sismember(bot_id..":Status:Basic", user_id) then
var = false
elseif redis:sismember(bot_id..":Status:programmer", user_id) then
var = false
elseif tonumber(user_id) == tonumber(bot_id) then  
var = false
elseif redis:sismember(bot_id..":Status:developer", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Creator", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Constructor", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Owner", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Administrator", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Vips", user_id) then
var = false
else  
var = true
end  
return var
end 
function Isrank(user_id,chat_id)
if devS(user_id) then  
var = false
elseif devB(user_id) then 
var = false
elseif redis:sismember(bot_id..":Status:Basic", user_id) then
var = false
elseif redis:sismember(bot_id..":Status:programmer", user_id) then
var = false
elseif tonumber(user_id) == tonumber(bot_id) then  
var = false
elseif redis:sismember(bot_id..":Status:developer", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Creator", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor", user_id) then
var = true
elseif redis:sismember(bot_id..":"..chat_id..":Status:Constructor", user_id) then
var = true
elseif redis:sismember(bot_id..":"..chat_id..":Status:Owner", user_id) then
var = true
elseif redis:sismember(bot_id..":"..chat_id..":Status:Administrator", user_id) then
var = true
elseif redis:sismember(bot_id..":"..chat_id..":Status:Vips", user_id) then
var = true
else  
var = true
end  
return var
end

function Total_message(msgs)  
local message = ''  
if tonumber(msgs) < 100 then 
message = 'غير متفاعل' 
elseif tonumber(msgs) < 200 then 
message = 'بده يتحسن' 
elseif tonumber(msgs) < 400 then 
message = 'شبه متفاعل' 
elseif tonumber(msgs) < 700 then 
message = 'متفاعل' 
elseif tonumber(msgs) < 1200 then 
message = 'متفاعل قوي' 
elseif tonumber(msgs) < 2000 then 
message = 'متفاعل جدا' 
elseif tonumber(msgs) < 3500 then 
message = 'اقوى تفاعل'  
elseif tonumber(msgs) < 4000 then 
message = 'متفاعل نار' 
elseif tonumber(msgs) < 4500 then 
message = 'قمة التفاعل' 
elseif tonumber(msgs) < 5500 then 
message = 'اقوى متفاعل' 
elseif tonumber(msgs) < 7000 then 
message = 'ملك التفاعل' 
elseif tonumber(msgs) < 9500 then 
message = 'امبراطور التفاعل' 
elseif tonumber(msgs) < 10000000000 then 
message = 'التفاعل كلو'  
end 
return message 
end
clock = os.clock
function sleep(n)
local t0 = clock()
while clock() - t0 <= n do end
end
function GetBio(User)
local var = "لا يوجد"
local url , res = https.request("https://api.telegram.org/bot"..Token.."/getchat?chat_id="..User);
data = json:decode(url)
if data.result.bio then
var = data.result.bio
end
return var
end
function GetInfoBot(msg)
local GetMemberStatus = bot.getChatMember(msg.chat_id,bot_id).status
if GetMemberStatus.can_change_info then
change_info = true else change_info = false
end
if GetMemberStatus.can_delete_messages then
delete_messages = true else delete_messages = false
end
if GetMemberStatus.can_invite_users then
invite_users = true else invite_users = false
end
if GetMemberStatus.can_pin_messages then
pin_messages = true else pin_messages = false
end
if GetMemberStatus.can_restrict_members then
restrict_members = true else restrict_members = false
end
if GetMemberStatus.can_promote_members then
promote = true else promote = false
end
return{
SetAdmin = promote,
BanUser = restrict_members,
Invite = invite_users,
PinMsg = pin_messages,
DelMsg = delete_messages,
Info = change_info
}
end
function GetSetieng(ChatId)
if redis:get(bot_id..":"..ChatId..":settings:".."messageVideo") == "del" then
messageVideo= "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVideo") == "ked" then 
messageVideo= "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVideo") == "ktm" then 
messageVideo= "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVideo") == "kick" then 
messageVideo= "بالطرد "   
else
messageVideo= "❌️"   
end   
if redis:get(bot_id..":"..ChatId..":settings:".."messagePhoto") == "del" then
messagePhoto = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePhoto") == "ked" then 
messagePhoto = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePhoto") == "ktm" then 
messagePhoto = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePhoto") == "kick" then 
messagePhoto = "بالطرد "   
else
messagePhoto = "❌️"   
end   
if redis:get(bot_id..":"..ChatId..":settings:".."JoinByLink") == "del" then
JoinByLink = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."JoinByLink") == "ked" then 
JoinByLink = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."JoinByLink") == "ktm" then 
JoinByLink = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."JoinByLink") == "kick" then 
JoinByLink = "بالطرد "   
else
JoinByLink = "❌️"   
end   
if redis:get(bot_id..":"..ChatId..":settings:".."WordsEnglish") == "del" then
WordsEnglish = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsEnglish") == "ked" then 
WordsEnglish = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsEnglish") == "ktm" then 
WordsEnglish = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsEnglish") == "kick" then 
WordsEnglish = "بالطرد "   
else
WordsEnglish = "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."WordsPersian") == "del" then
WordsPersian = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsPersian") == "ked" then 
WordsPersian = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsPersian") == "ktm" then 
WordsPersian = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsPersian") == "kick" then 
WordsPersian = "بالطرد "   
else
WordsPersian = "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageVoiceNote") == "del" then
messageVoiceNote = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVoiceNote") == "ked" then 
messageVoiceNote = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVoiceNote") == "ktm" then 
messageVoiceNote = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVoiceNote") == "kick" then 
messageVoiceNote = "بالطرد "   
else
messageVoiceNote = "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageSticker") == "del" then
messageSticker= "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageSticker") == "ked" then 
messageSticker= "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageSticker") == "ktm" then 
messageSticker= "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageSticker") == "kick" then 
messageSticker= "بالطرد "   
else
messageSticker= "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."AddMempar") == "del" then
AddMempar = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."AddMempar") == "ked" then 
AddMempar = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."AddMempar") == "ktm" then 
AddMempar = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."AddMempar") == "kick" then 
AddMempar = "بالطرد "   
else
AddMempar = "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageAnimation") == "del" then
messageAnimation = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageAnimation") == "ked" then 
messageAnimation = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageAnimation") == "ktm" then 
messageAnimation = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageAnimation") == "kick" then 
messageAnimation = "بالطرد "   
else
messageAnimation = "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageDocument") == "del" then
messageDocument= "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageDocument") == "ked" then 
messageDocument= "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageDocument") == "ktm" then 
messageDocument= "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageDocument") == "kick" then 
messageDocument= "بالطرد "   
else
messageDocument= "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageAudio") == "del" then
messageAudio = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageAudio") == "ked" then 
messageAudio = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageAudio") == "ktm" then 
messageAudio = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageAudio") == "kick" then 
messageAudio = "بالطرد "   
else
messageAudio = "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messagePoll") == "del" then
messagePoll = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePoll") == "ked" then 
messagePoll = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePoll") == "ktm" then 
messagePoll = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePoll") == "kick" then 
messagePoll = "بالطرد "   
else
messagePoll = "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageVideoNote") == "del" then
messageVideoNote = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVideoNote") == "ked" then 
messageVideoNote = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVideoNote") == "ktm" then 
messageVideoNote = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVideoNote") == "kick" then 
messageVideoNote = "بالطرد "   
else
messageVideoNote = "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageContact") == "del" then
messageContact = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageContact") == "ked" then 
messageContact = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageContact") == "ktm" then 
messageContact = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageContact") == "kick" then 
messageContact = "بالطرد "   
else
messageContact = "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageLocation") == "del" then
messageLocation = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageLocation") == "ked" then 
messageLocation = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageLocation") == "ktm" then 
messageLocation = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageLocation") == "kick" then 
messageLocation = "بالطرد "   
else
messageLocation = "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Cmd") == "del" then
Cmd = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Cmd") == "ked" then 
Cmd = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Cmd") == "ktm" then 
Cmd = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Cmd") == "kick" then 
Cmd = "بالطرد "   
else
Cmd = "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageSenderChat") == "del" then
messageSenderChat = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageSenderChat") == "ked" then 
messageSenderChat = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageSenderChat") == "ktm" then 
messageSenderChat = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageSenderChat") == "kick" then 
messageSenderChat = "بالطرد "   
else
messageSenderChat = "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messagePinMessage") == "del" then
messagePinMessage = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePinMessage") == "ked" then 
messagePinMessage = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePinMessage") == "ktm" then 
messagePinMessage = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePinMessage") == "kick" then 
messagePinMessage = "بالطرد "   
else
messagePinMessage = "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Keyboard") == "del" then
Keyboard = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Keyboard") == "ked" then 
Keyboard = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Keyboard") == "ktm" then 
Keyboard = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Keyboard") == "kick" then 
Keyboard = "بالطرد "   
else
Keyboard = "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Username") == "del" then
Username = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Username") == "ked" then 
Username = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Username") == "ktm" then 
Username = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Username") == "kick" then 
Username = "بالطرد "   
else
Username = "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Tagservr") == "del" then
Tagservr = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Tagservr") == "ked" then 
Tagservr = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Tagservr") == "ktm" then 
Tagservr = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Tagservr") == "kick" then 
Tagservr = "بالطرد "   
else
Tagservr = "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."WordsFshar") == "del" then
WordsFshar = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsFshar") == "ked" then 
WordsFshar = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsFshar") == "ktm" then 
WordsFshar = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsFshar") == "kick" then 
WordsFshar = "بالطرد "   
else
WordsFshar = "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Markdaun") == "del" then
Markdaun = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Markdaun") == "ked" then 
Markdaun = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Markdaun") == "ktm" then 
Markdaun = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Markdaun") == "kick" then 
Markdaun = "بالطرد "   
else
Markdaun = "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Links") == "del" then
Links = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Links") == "ked" then 
Links = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Links") == "ktm" then 
Links = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Links") == "kick" then 
Links = "بالطرد "   
else
Links = "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."forward_info") == "del" then
forward_info = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."forward_info") == "ked" then 
forward_info = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."forward_info") == "ktm" then 
forward_info = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."forward_info") == "kick" then 
forward_info = "بالطرد "   
else
forward_info = "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageChatAddMembers") == "del" then
messageChatAddMembers = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageChatAddMembers") == "ked" then 
messageChatAddMembers = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageChatAddMembers") == "ktm" then 
messageChatAddMembers = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageChatAddMembers") == "kick" then 
messageChatAddMembers = "بالطرد "   
else
messageChatAddMembers = "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."via_bot_user_id") == "del" then
via_bot_user_id = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."via_bot_user_id") == "ked" then 
via_bot_user_id = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."via_bot_user_id") == "ktm" then 
via_bot_user_id = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."via_bot_user_id") == "kick" then 
via_bot_user_id = "بالطرد "   
else
via_bot_user_id = "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Hashtak") == "del" then
Hashtak = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Hashtak") == "ked" then 
Hashtak = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Hashtak") == "ktm" then 
Hashtak = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Hashtak") == "kick" then 
Hashtak = "بالطرد "   
else
Hashtak = "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Edited") == "del" then
Edited = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Edited") == "ked" then 
Edited = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Edited") == "ktm" then 
Edited = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Edited") == "kick" then 
Edited = "بالطرد "   
else
Edited = "❌️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Spam") == "del" then
Spam = "✅️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Spam") == "ked" then 
Spam = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Spam") == "ktm" then 
Spam = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Spam") == "kick" then 
Spam = "بالطرد "   
else
Spam = "❌️"   
end    
if redis:hget(bot_id.."Spam:Group:User"..ChatId,"Spam:User") == "kick" then 
flood = "بالطرد "   
elseif redis:hget(bot_id.."Spam:Group:User"..ChatId,"Spam:User") == "del" then 
flood = "✅️" 
elseif redis:hget(bot_id.."Spam:Group:User"..ChatId,"Spam:User") == "ked" then
flood = "بالتقييد "   
elseif redis:hget(bot_id.."Spam:Group:User"..ChatId,"Spam:User") == "ktm" then
flood = "بالكتم "    
else
flood = "❌️"   
end     
return {
flood = flood,
Spam = Spam,
Edited = Edited,
Hashtak = Hashtak,
messageChatAddMembers = messageChatAddMembers,
via_bot_user_id = via_bot_user_id,
Markdaun = Markdaun,
Links = Links,
forward_info = forward_info ,
Username = Username,
WordsFshar = WordsFshar,
Tagservr = Tagservr,
messagePinMessage = messagePinMessage,
messageSenderChat = messageSenderChat,
Keyboard = Keyboard,
messageLocation = messageLocation,
Cmd = Cmd,
messageContact =messageContact,
messageAudio = messageAudio,
messageVideoNote = messageVideoNote,
messagePoll = messagePoll,
messageDocument= messageDocument,
messageAnimation = messageAnimation,
AddMempar = AddMempar,
messageSticker= messageSticker,
messageUnsupported= messageUnsupported,
WordsPersian = WordsPersian,
messageVoiceNote = messageVoiceNote,
JoinByLink = JoinByLink,
messagePhoto = messagePhoto,
WordsEnglish = WordsEnglish,
messageVideo= messageVideo
}
end
function Reply_Status(UserId,TextMsg)
UserInfo = bot.getUser(UserId)
tagname = UserInfo.first_name
tagname = tagname:gsub('"',"")
tagname = tagname:gsub('"',"")
tagname = tagname:gsub("`","")
tagname = tagname:gsub("*","") 
tagname = tagname:gsub("_","")
tagname = tagname:gsub("]","")
tagname = tagname:gsub("[[]","")
if UserInfo.username and UserInfo.username ~= "" then
UserInfousername = '['..tagname..'](t.me/'..UserInfo.username..')'
else
UserInfousername = '['..tagname..'](tg://user?id='..UserId..')'
end
return {
user = UserInfousername,
by   = '\n*⤈︙ بواسطه :* '..UserInfousername..' \n'..TextMsg..'\n',
i   = '\n*⤈︙ العضو :* '..UserInfousername..' \n'..TextMsg..'\n',
yu    = '\n*⤈︙ عزيزي :* '..UserInfousername..' \n'..TextMsg..'\n',
helo   = '\n*⤈︙ المستخدم :* '..UserInfousername..' \n'..TextMsg..'\n',
heloo   = '\n '..UserInfousername..' \n'..TextMsg..'\n'
}
end
function getJson(R)  
programmer = redis:smembers(bot_id..":Status:programmer")
developer = redis:smembers(bot_id..":Status:developer")
user_id = redis:smembers(bot_id..":user_id")
chat_idgr = redis:smembers(bot_id..":Groups")
local fresuult = {
programmer = programmer,
developer = developer,
chat_id = chat_idgr,
user_id = user_id, 
bot = bot_id
} 
gresuult = {} 
for k,v in pairs(chat_idgr) do   
Creator = redis:smembers(bot_id..":"..v..":Status:Creator")
if Creator then
cre = {ids = Creator}
end
BasicConstructor = redis:smembers(bot_id..":"..v..":Status:BasicConstructor")
if BasicConstructor then
bc = {ids = BasicConstructor}
end
Constructor = redis:smembers(bot_id..":"..v..":Status:Constructor")
if Constructor then
cr = {ids = Constructor}
end
Owner = redis:smembers(bot_id..":"..v..":Status:Owner")
if Owner then
on = {ids = Owner}
end
Administrator = redis:smembers(bot_id..":"..v..":Status:Administrator")
if Administrator then
ad = {ids = Administrator}
end
Vips = redis:smembers(bot_id..":"..v..":Status:Vips")
if Vips then
vp = {ids = Vips}
end
gresuult[v] = {
BasicConstructor = bc,
Administrator = ad, 
Constructor = cr, 
Creator = cre, 
Owner = on,
Vips = vp
}
end
local resuult = {
bot = fresuult,
groups = gresuult
}
local File = io.open('./'..bot_id..'.json', "w")
File:write(JSON.encode (resuult))
File:close()
bot.sendDocument(R,0,'./'..bot_id..'.json', '⤈︙  تم جلب النسخه الاحتياطيه', 'md')
end
function oger(Message)
year = math.floor(Message / 31536000)
byear = Message % 31536000 
month = math.floor(byear / 2592000)
bmonth = byear % 2592000 
day = math.floor(bmonth / 86400)
bday = bmonth % 86400 
hours = math.floor( bday / 3600)
bhours = bday % 3600 
minx = math.floor(bhours / 60)
sec = math.floor(bhours % 3600) % 60
return string.format("%02d:%02d", minx, sec)
end
function download(url,name)
if not name then
name = url:match('([^/]+)$')
end
if string.find(url,'https') then
data,res = https.request(url)
elseif string.find(url,'http') then
data,res = http.request(url)
else
return 'The link format is incorrect.'
end
if res ~= 200 then
return 'check url , error code : '..res
else
file = io.open(name,'wb')
file:write(data)
file:close()
return './'..name
end
end
function Run_Callback()
local Get_Files  = io.popen("curl -s https://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@raw.githubusercontent.com/33yyllcc/XXYAYYYYYYFIELS/main/getfile.json"):read('*a')
if Get_Files  and Get_Files ~= "404: Not Found" then
local json = JSON.decode(Get_Files)
for v,k in pairs(json.plugins_) do
local CheckFileisFound = io.open("hso_Files/"..v,"r")
if CheckFileisFound then
io.close(CheckFileisFound)
dofile("hso_Files/"..v)
end
end
end
end
function Return_Callback(msg)
local Get_Files  = io.popen("curl -s https://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@raw.githubusercontent.com/33yyllcc/XXYAYYYYYYFIELS/main/getfile.json"):read('*a')
if Get_Files  and Get_Files ~= "404: Not Found" then
local json = JSON.decode(Get_Files)
for v,k in pairs(json.plugins_) do
local CheckFileisFound = io.open("hso_Files/"..v,"r")
if CheckFileisFound then
io.close(CheckFileisFound)
if v == "simsim.lua" then
simsim(msg)
end
if v == "Rdodbot.lua" then
Rdodbot(msg)
end
if v == "changingname.lua" then
changingname(msg)
end
if v == "chencherusername.lua" then
chencherusername(msg)
end
end
end
end
end
function key_Callback(ub)
local Get_Files  = io.popen("curl -s https://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@raw.githubusercontent.com/33yyllcc/XXYAYYYYYYFIELS/main/getfile.json"):read('*a')
local datar = {}
if Get_Files  and Get_Files ~= "404: Not Found" then
local json = JSON.decode(Get_Files)
for v,k in pairs(json.plugins_) do
local CheckFileisFound = io.open("hso_Files/"..v,"r")
if CheckFileisFound then
io.close(CheckFileisFound)
datar[k] = {{text =v,data ="DoOrDel_"..ub.."_"..v},{text ="مفعل",data ="DoOrDel_"..ub.."_"..v}}
else
datar[k] = {{text =v,data ="DoOrDel_"..ub.."_"..v},{text ="معطل",data ="DoOrDel_"..ub.."_"..v}}
end
end
datar[#json.plugins_ +1] = {{text = "‹ YAYYYYYY X ›",url ="https://t.me/YAYYYYYY"}}
end
return datar
end
function redis_get(ChatId,tr)
if redis:get(bot_id..":"..ChatId..":settings:"..tr)  then
tf = "✅️" 
else
tf = "❌️"   
end    
return tf
end
function nfGdone(msg,chat,Rank,Type)
if Creator(msg) then
return false  
end
if redis:get(bot_id..":"..chat..":"..Type..":RankrestrictionGdone:"..Rank) then
return true  
else  
return false  
end
end
function Gdone(chat,Rank,Type)
if redis:get(bot_id..":"..chat..":"..Type..":RankrestrictionGdone:"..Rank) then
infosend  = "❌️"
else
infosend = "✅️"
end
return infosend
end
function restrictionGet_Rank(user_id,chat_id)
if redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor", user_id) then
var = "BasicConstructor"
elseif redis:sismember(bot_id..":"..chat_id..":Status:Constructor", user_id) then
var = "Constructor"
elseif redis:sismember(bot_id..":"..chat_id..":Status:Owner", user_id) then
var = "Owner"
elseif redis:sismember(bot_id..":"..chat_id..":Status:Administrator", user_id) then
var = "Administrator"
elseif redis:sismember(bot_id..":"..chat_id..":Status:Vips", user_id) then
var = "Vips"
else  
var = "mem"
end  
return var
end 
function nfRankrestriction(msg,chat,Rank,Type)
if Creator(msg) then
return false  
end
if redis:get(bot_id..":"..chat..":"..Type..":Rankrestriction:"..Rank) then
return true  
else  
return false  
end
end
function Rankrestriction(chat,Rank,Type)
if redis:get(bot_id..":"..chat..":"..Type..":Rankrestriction:"..Rank) then
infosend  = "❌️"
else
infosend = "✅️"
end
return infosend
end
function Adm_Callback()
if redis:get(bot_id..":Twas") then
Twas = "✅️"
else
Twas = "❌️"
end
if redis:get(bot_id..":Notice") then
Notice = "✅️"
else
Notice = "❌️"
end
if redis:get(bot_id..":Departure") then
Departure  = "✅️"
else
Departure = "❌️"
end
if redis:get(bot_id..":sendbot") then
sendbot  = "✅️"
else
sendbot = "❌️"
end
if redis:get(bot_id..":infobot") then
infobot  = "✅️"
else
infobot = "❌️"
end
if redis:get(bot_id..":addu") then
addu  = "✅️"
else
addu = "❌️"
end
if redis:get(bot_id..":Autoadd") then
Autoadd  = "✅️"
else
Autoadd = "❌️"
end
return {
Add   = Autoadd,
t   = Twas,
n   = Notice,
d   = Departure,
s   = sendbot,
addu   = addu,
i    = infobot
}
end
---------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
io.popen("mkdir hso_Files")
print("\27[34m"..[[>> mkdir hso_Files Done]].."\27[m")
----------------------------------------------------------------------------------------------------
function sEndDon(url)
local get = io.popen('curl -s "https://botslua.tk/yt/Api.php?ID='..URL.escape(url)..'&TYPE=voice"'):read('*a')
local InfoVid = JSON.decode(get)
return InfoVid
end
function send(method,database,yok)
local function a(b)
return string.format("%%%02X",string.byte(b))
end
function c(b)
local b=string.gsub(b,"\\","\\")
local b=string.gsub(b,"([^%w])",a)
return b
end
local function d(e)
local f=""
for g,h in pairs(e) do 
if type(h)=='table'then 
for i,j in ipairs(h) do 
f=f..string.format("%s[]=%s&",g,c(j))
end
else f=f..string.format("%s=%s&",g,c(h))
end
end
local f=string.reverse(string.gsub(string.reverse(f),"&","",1))
return f 
end 
if database.message_id then
database.message_id = (database.message_id/2097152/0.5)
end
if database.reply_to_message_id then
database.reply_to_message_id = (database.reply_to_message_id/2097152/0.5)
end 
local url , res = https.request("https://api.telegram.org/bot"..(yok or Token).."/"..method.."?"..d(database))
data = JSON.decode(url)
return data 
end
function Callback(data)
----------------------------------------------------------------------------------------------------
Text = bot.base64_decode(data.payload.data)
user_id = data.sender_user_id
chat_id = data.chat_id
msg_id = data.message_id
--------------------------------
if Text and Text:match("^EditIdDone_(.*)_(.*)") then
local infomsg = {Text:match("^EditIdDone_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
return bot.answerCallbackQuery(data.id,"⤈︙ عذرا الامر لا يخصك .", true)
end
local ListIDtxt = {'◇︰Msgs : #msgs .\n◇︰ID : #id .\n◇︰Stast : #stast .\n◇︰UserName : #username .\n','˛ َ𝖴ᥱ᥉ : #username  .\n˛ َ𝖲𝗍ُɑِ  : #stast   . \n˛ َ𝖨ժ : #id  .\n˛ َ𝖬⁪⁬⁮᥉𝗀ِ : #msgs   .\n','⚕ 𓆰 𝑾𝒆𝒍𝒄𝒐𝒎𝒆 𝑻𝒐 𝑮𝒓𝒐𝒖𝒑 ★\n- 🖤 | 𝑼𝑬𝑺 : #username\n- 🖤 | 𝑺𝑻𝑨 : #stast\n- 🖤 | 𝑰𝑫 : #id\n- 🖤 | 𝑴𝑺𝑮 : #msgs\n','◇︰𝖬𝗌𝗀𝗌 : #msgs  .\n◇︰𝖨𝖣 : #id  .\n◇︰𝖲𝗍𝖺𝗌𝗍 : #stast .\n◇︰UserName : #username .\n','⌁ Use ⇨{#username}\n⌁ Msg⇨ {#msgs}\n⌁ Sta ⇨ {#stast}\n⌁ iD ⇨{#id}\n▿▿▿','゠𝚄𝚂𝙴𝚁 𖨈 #username 𖥲 .\n゠𝙼𝚂𝙶 𖨈 #msgs 𖥲 .\n゠𝚂𝚃𝙰 𖨈 #stast 𖥲 .\n゠𝙸𝙳 𖨈 #id 𖥲 .\n','\n▹ 𝙐𝙎𝙀𝙍 𖨄 #username  𖤾.\n▹ 𝙈𝙎𝙂𝙎 𖨄 #msgs  𖤾.\n▹ 𝙎𝙏𝘼𝙎𝙏 𖨄 #stast  𖤾.\n▹ 𝙄𝘿 𖨄 #id 𖤾.\n','\n➼ : 𝐼𝐷 𖠀 #id\n➼ : 𝑈𝑆𝐸𝑅 𖠀 #username\n➼ : 𝑀𝑆𝐺𝑆 𖠀 #msgs\n➼ : 𝑆𝑇𝐴S𝑇 𖠀 #stast\n➼ : 𝐸𝐷𝐼𝑇  𖠀 #edit\n','\n┌ 𝐔𝐒𝐄𝐑 𖤱 #username 𖦴 .\n├ 𝐌𝐒𝐆𝐒 𖤱 #msgs 𖦴 .\n├ 𝐒𝐓𝐀 𖤱 #stast 𖦴 .\n└ 𝐈𝐃 𖤱 #id 𖦴 .\n','\n୫ 𝙐𝙎𝙀𝙍𝙉𝘼𝙈𝙀 ➤ #username\n୫ 𝙈𝙀𝙎𝙎𝘼𝙂𝙀𝙎 ➤ #msgs\n୫ 𝙎𝙏𝘼𝙏𝙎 ➤ #stast\n୫ 𝙄𝘿 ➤ #id\n','\n☆-𝐮𝐬𝐞𝐫 : #username 𖣬\n☆-𝐦𝐬𝐠  : #msgs 𖣬\n☆-𝐬𝐭𝐚 : #stast 𖣬\n☆-𝐢𝐝  : #id 𖣬\n','\n𝐘𝐨𝐮𝐫 𝐈𝐃 ☤🇮🇶- #id\n𝐔𝐬𝐞𝐫𝐍𝐚☤🇮🇶- #username\n𝐒𝐭𝐚𝐬𝐓 ☤🇮🇶- #stast\n𝐌𝐬𝐠𝐒☤🇮🇶 - #msgs\n','\n.𖣂 𝙪𝙨𝙚𝙧𝙣𝙖𝙢𝙚 , #username\n.𖣂 𝙨𝙩𝙖𝙨𝙩 , #stast\n.𖣂 𝙄𝘿 , #id\n.𖣂 𝙂𝙖𝙢𝙨 , #game\n.𖣂 𝙢𝙨𝙂𝙨 , #msgs\n'}
Text_Rand = ListIDtxt[tonumber(infomsg[2])]
redis:set(bot_id..":"..chat_id..":id",Text_Rand)
bot.editMessageText(chat_id,msg_id,"*⤈︙ تم تعيين الايدي بنجاح .*", 'md')
end
if Text and Text:match("^EditIdskip_(.*)_(.*)") then
local infomsg = {Text:match("^EditIdskip_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
return bot.answerCallbackQuery(data.id,"⤈︙ عذرا الامر لا يخصك .", true)
end
local ListIDtxt = {'◇︰Msgs : #msgs .\n◇︰ID : #id .\n◇︰Stast : #stast .\n◇︰UserName : #username .\n','˛ َ𝖴ᥱ᥉ : #username  .\n˛ َ𝖲𝗍ُɑِ  : #stast   . \n˛ َ𝖨ժ : #id  .\n˛ َ𝖬⁪⁬⁮᥉𝗀ِ : #msgs   .\n','⚕ 𓆰 𝑾𝒆𝒍𝒄𝒐𝒎𝒆 𝑻𝒐 𝑮𝒓𝒐𝒖𝒑 ★\n- 🖤 | 𝑼𝑬𝑺 : #username\n- 🖤 | 𝑺𝑻𝑨 : #stast\n- 🖤 | 𝑰𝑫 : #id\n- 🖤 | 𝑴𝑺𝑮 : #msgs\n','◇︰𝖬𝗌𝗀𝗌 : #msgs  .\n◇︰𝖨𝖣 : #id  .\n◇︰𝖲𝗍𝖺𝗌𝗍 : #stast .\n◇︰UserName : #username .\n','⌁ Use ⇨{#username}\n⌁ Msg⇨ {#msgs}\n⌁ Sta ⇨ {#stast}\n⌁ iD ⇨{#id}\n▿▿▿','゠𝚄𝚂𝙴𝚁 𖨈 #username 𖥲 .\n゠𝙼𝚂𝙶 𖨈 #msgs 𖥲 .\n゠𝚂𝚃𝙰 𖨈 #stast 𖥲 .\n゠𝙸𝙳 𖨈 #id 𖥲 .\n','\n▹ 𝙐𝙎𝙀𝙍 𖨄 #username  𖤾.\n▹ 𝙈𝙎𝙂𝙎 𖨄 #msgs  𖤾.\n▹ 𝙎𝙏𝘼𝙎𝙏 𖨄 #stast  𖤾.\n▹ 𝙄𝘿 𖨄 #id 𖤾.\n','\n➼ : 𝐼𝐷 𖠀 #id\n➼ : 𝑈𝑆𝐸𝑅 𖠀 #username\n➼ : 𝑀𝑆𝐺𝑆 𖠀 #msgs\n➼ : 𝑆𝑇𝐴S𝑇 𖠀 #stast\n➼ : 𝐸𝐷𝐼𝑇  𖠀 #edit\n','\n┌ 𝐔𝐒𝐄𝐑 𖤱 #username 𖦴 .\n├ 𝐌𝐒𝐆𝐒 𖤱 #msgs 𖦴 .\n├ 𝐒𝐓𝐀 𖤱 #stast 𖦴 .\n└ 𝐈𝐃 𖤱 #id 𖦴 .\n','\n୫ 𝙐𝙎𝙀𝙍𝙉𝘼𝙈𝙀 ➤ #username\n୫ 𝙈𝙀𝙎𝙎𝘼𝙂𝙀𝙎 ➤ #msgs\n୫ 𝙎𝙏𝘼𝙏𝙎 ➤ #stast\n୫ 𝙄𝘿 ➤ #id\n','\n☆-𝐮𝐬𝐞𝐫 : #username 𖣬\n☆-𝐦𝐬𝐠  : #msgs 𖣬\n☆-𝐬𝐭𝐚 : #stast 𖣬\n☆-𝐢𝐝  : #id 𖣬\n','\n𝐘𝐨𝐮𝐫 𝐈𝐃 ☤🇮🇶- #id\n𝐔𝐬𝐞𝐫𝐍𝐚☤🇮🇶- #username\n𝐒𝐭𝐚𝐬𝐓 ☤🇮🇶- #stast\n𝐌𝐬𝐠𝐒☤🇮🇶 - #msgs\n','\n.𖣂 𝙪𝙨𝙚𝙧𝙣𝙖𝙢𝙚 , #username\n.𖣂 𝙨𝙩𝙖𝙨𝙩 , #stast\n.𖣂 𝙄𝘿 , #id\n.𖣂 𝙂𝙖𝙢𝙨 , #game\n.𖣂 𝙢𝙨𝙂𝙨 , #msgs\n'}
nListIDtxt = math.random(1,#ListIDtxt)
if tonumber(infomsg[2]) == tonumber(nListIDtxt) then
nListIDtxt = math.random(1,#ListIDtxt)
end
Text_Rand = ListIDtxt[tonumber(nListIDtxt)]
bot.editMessageText(chat_id,msg_id,Reply_Status(data.sender_user_id,"*⤈︙ هل تريد تعيين هذهِ الكليشة للايدي .*\n"..Text_Rand.."\n)").yu, 'md', true, false, bot.replyMarkup{type = 'inline',data = {{{text ='‹ تأكيد ›',data="EditIdDone_"..data.sender_user_id.."_"..nListIDtxt},{text = '‹ تخطي ›',data="EditIdskip_"..data.sender_user_id.."_"..nListIDtxt}},{{text = '‹ الغاء ›',data="Sur_"..data.sender_user_id.."_2"}},}})
bot.answerCallbackQuery(data.id, "*⤈︙ تم تحديث كليشة الايدي .*")
end
--------------------------------
if Text and Text:match("^DoOrDel_(.*)_(.*)") then
local infomsg = {Text:match("^DoOrDel_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
return bot.answerCallbackQuery(data.id, "- عذراً الامر لا يخصك", true)
end
local st1 = "- اهلا بك في متجر ملفات السورس ."
local FileName = infomsg[2]
local File_Run = io.open("hso_Files/"..FileName,"r")
if File_Run then
io.close(File_Run)
bot.answerCallbackQuery(data.id,"- تم تعطيل الملف "..FileName.." بنجاح .", true)
os.execute("rm -fr hso_Files/"..FileName)
else
rel = io.popen('curl -s https://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@raw.githubusercontent.com/33yyllcc/XXYAYYYYYYFIELS/main/Files/'..FileName):read('*a')
if rel  and rel == "404: Not Found" then
return bot.answerCallbackQuery(data.id, "- الملف غير موجود داخل مستودع الملفات .", true)
end
bot.answerCallbackQuery(data.id,"- تم تفعيل الملف "..FileName.." بنجاح .", true)
local GetJson = io.popen('curl -s https://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@raw.githubusercontent.com/33yyllcc/XXYAYYYYYYFIELS/main/Files/'..FileName):read('*a')
local File = io.open('./hso_Files/'..FileName,"w")
File:write(GetJson)
File:close()
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = key_Callback(data.sender_user_id)
}
st1 = st1.."\n- اضغط على اسم الملف لتفعيله او تعطيله."
bot.editMessageText(chat_id,msg_id,st1, 'md', true, false, reply_markup)
dofile('start.lua')
end
function IsStatu(Status,user_id,chat_id)
if Status == "programmer" or Status == "developer" then
Statusend =bot_id..":Status:"..Status
else
Statusend = bot_id..":"..chat_id..":Status:"..Status
end
if redis:sismember(Statusend,user_id) then
var = '✅️'
else
var = '❌️'
end
return var
end 
function GetAdminsNum(chat_id,user_id)
local GetMemberStatus = bot.getChatMember(chat_id,user_id).status
if GetMemberStatus.can_change_info then
change_info = 1 else change_info = 0
end
if GetMemberStatus.can_delete_messages then
delete_messages = 1 else delete_messages = 0
end
if GetMemberStatus.can_invite_users then
invite_users = 1 else invite_users = 0
end
if GetMemberStatus.can_pin_messages then
pin_messages = 1 else pin_messages = 0
end
if GetMemberStatus.can_restrict_members then
restrict_members = 1 else restrict_members = 0
end
if GetMemberStatus.can_promote_members then
promote = 1 else promote = 0
end
return{
promote = promote,
restrict_members = restrict_members,
invite_users = invite_users,
pin_messages = pin_messages,
delete_messages = delete_messages,
change_info = change_info
}
end
function addStatu(Status,user_id,chat_id)
if Status == "programmer" or Status == "developer" then
Statusend =bot_id..":Status:"..Status
else
Statusend = bot_id..":"..chat_id..":Status:"..Status
end
if redis:sismember(Statusend,user_id) then
redis:srem(Statusend,user_id)
else
redis:sadd(Statusend,user_id) 
end
return var
end  

if Text and Text:match("^marriage_(.*)_(.*)_(.*)_(.*)") then
local infomsg = {Text:match("^marriage_(.*)_(.*)_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[2]) then
bot.answerCallbackQuery(data.id,"‹ . انت شعليك . ›",true)
return false
end
if infomsg[4] =="No" then
local UserInfo = bot.getUser(infomsg[1])
local UserInfo1 = bot.getUser(infomsg[2])
if UserInfo.username and UserInfo.username ~= "" then
us1 = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
else
us1 = '['..UserInfo.first_name..'](tg://user?id='..UserInfo.id..')'
end
if UserInfo1.username and UserInfo1.username ~= "" then
us = '['..UserInfo1.first_name..'](t.me/'..UserInfo1.username..')'
else
us = '['..UserInfo1.first_name..'](tg://user?id='..UserInfo1.id..')'
end
bot.editMessageText(chat_id,msg_id,"*~︙تم رفض الزواج من* ‹ "..us1.." ›","md",true)  
elseif infomsg[4] =="OK" then
redis:set(bot_id..":"..chat_id..":marriage:"..infomsg[1],infomsg[2]) 
redis:set(bot_id..":"..chat_id..":marriage:"..infomsg[2],infomsg[1]) 
redis:sadd(bot_id..":"..chat_id.."couples",infomsg[1])
redis:sadd(bot_id..":"..chat_id.."wives",infomsg[2])
bot.editMessageText(chat_id,msg_id,"*~︙تم قبول الزواج من* ‹ "..us.." ›","md",true)  
end
end

function GetAdminsSlahe(chat_id,user_id,user2,msg_id,t1,t2,t3,t4,t5,t6)
local GetMemberStatus = bot.getChatMember(chat_id,user2).status
if GetMemberStatus.can_change_info then
change_info = ' ✅️️ ' else change_info =' ❌️ '
end
if GetMemberStatus.can_delete_messages then
delete_messages = ' ✅️️ ' else delete_messages =' ❌️ '
end
if GetMemberStatus.can_invite_users then
invite_users = ' ✅️️ ' else invite_users =' ❌️ '
end
if GetMemberStatus.can_pin_messages then
pin_messages = ' ✅️️ ' else pin_messages =' ❌️ '
end
if GetMemberStatus.can_restrict_members then
restrict_members = ' ✅️️ ' else restrict_members =' ❌️ '
end
if GetMemberStatus.can_promote_members then
promote = ' ✅️️ ' else promote =' ❌️ '
end
local reply_markupp = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'تغيير المعلومات '..(t1 or change_info), data = user_id..'/groupNum1//'..user2},
},
{
{text = 'حظر المستخدمين '..(t3 or restrict_members), data = user_id..'/groupNum3//'..user2},{text = 'دعوة المستخدمين '..(t4 or invite_users), data = user_id..'/groupNum4//'..user2}, 
},
{
{text = 'مسح الرسائل '..(t5 or delete_messages), data = user_id..'/groupNum5//'..user2},{text = 'تثبيت الرسائل '..(t2 or pin_messages), data = user_id..'/groupNum2//'..user2}, 
},
{
{text = 'اضافة مشرفين '..(t6 or promote), data = user_id..'/groupNum6//'..user2}, 
},
{
{text = '‹ اخفاء ›', data ='/delAmr'}
},
}
}
bot.editMessageText(chat_id,msg_id,"⤈︙ انقر لتحديد صلاحيات المشرف .", 'md', false, false, reply_markupp)
end
function GetAdminsNum(chat_id,user_id)
local GetMemberStatus = bot.getChatMember(chat_id,user_id).status
if GetMemberStatus.can_change_info then
change_info = 1 else change_info = 0
end
if GetMemberStatus.can_delete_messages then
delete_messages = 1 else delete_messages = 0
end
if GetMemberStatus.can_invite_users then
invite_users = 1 else invite_users = 0
end
if GetMemberStatus.can_pin_messages then
pin_messages = 1 else pin_messages = 0
end
if GetMemberStatus.can_restrict_members then
restrict_members = 1 else restrict_members = 0
end
if GetMemberStatus.can_promote_members then
promote = 1 else promote = 0
end
return{
promote = promote,
restrict_members = restrict_members,
invite_users = invite_users,
pin_messages = pin_messages,
delete_messages = delete_messages,
change_info = change_info
}
end

if Text and Text:match('(.*)/zwag_yes/(.*)/mahr/(.*)') then
local Data = {Text:match('(.*)/zwag_yes/(.*)/mahr/(.*)')}
if tonumber(Data[1]) ~= tonumber(user_id) then
return bot.answerCallbackQuery(data.id, "شو رأيك نزوجك بدالهم ؟", true)
end
if tonumber(user_id) == tonumber(Data[1]) then
if redis:get(bot_id.."zwag_request:"..Data[1]) then
local zwga_id = tonumber(Data[1])
local zwg_id = tonumber(Data[2])
local coniss = Data[3]
local zwg = bot.getUser(zwg_id)
local zwga = bot.getUser(zwga_id)
local zwg_tag = '['..zwg.first_name.."](tg://user?id="..zwg_id..")"
local zwga_tag = '['..zwga.first_name.."](tg://user?id="..zwga_id..")"
local hadddd = tonumber(coniss)
ballanceekk = tonumber(coniss) / 100 * 15
ballanceekkk = tonumber(coniss) - ballanceekk
local convert_mony = string.format("%.0f",ballanceekkk)
ballancee = redis:get(bot_id.."boob"..zwg_id) or 0
ballanceea = redis:get(bot_id.."boob"..zwga_id) or 0
zogtea = ballanceea + ballanceekkk
zeugh = ballancee - tonumber(coniss)
redis:set(bot_id.."boob"..zwg_id , math.floor(zeugh))
redis:sadd(bot_id.."roogg1",zwg_id)
redis:sadd(bot_id.."roogga1",zwga_id)
redis:set(bot_id.."roog1"..zwg_id,zwg_id)
redis:set(bot_id.."rooga1"..zwg_id,zwga_id)
redis:set(bot_id.."roogte1"..zwga_id,zwga_id)
redis:set(bot_id.."rahr1"..zwg_id,tonumber(coniss))
redis:set(bot_id.."rahr1"..zwga_id,tonumber(coniss))
redis:set(bot_id.."roog1"..zwga_id,zwg_id)
redis:set(bot_id.."rahrr1"..zwg_id,math.floor(ballanceekkk))
redis:set(bot_id.."rooga1"..zwga_id,zwga_id)
redis:set(bot_id.."rahrr1"..zwga_id,math.floor(ballanceekkk))
return bot.editMessageText(chat_id,msg_id,"كولولولولويششش\nاليوم عقدنا قران :\n\nالزوج "..zwg_tag.." 🤵🏻\n   💗\nالزوجة "..zwga_tag.." 👰??‍♀️\nالمهر : "..convert_mony.." دينار بعد الضريبة 15%\nعلمود تشوفون وثيقة زواجكم اكتبوا : زواجي", 'md', false)
else
return bot.editMessageText(chat_id,msg_id,"انتهى الطلب وين كنتي لما طلب ايدك", 'md', false)
end
end
end
if Text and Text:match('(%d+)/zwag_no/(%d+)') then
local UserId = {Text:match('(%d+)/zwag_no/(%d+)')}
if tonumber(UserId[1]) ~= tonumber(user_id) then
return bot.answerCallbackQuery(data.id, "شو رأيك نزوجك بدالهم ؟", true)
else
redis:del(bot_id.."zwag_request:"..UserId[1])
redis:del(bot_id.."zwag_request:"..UserId[2])
return bot.editMessageText(chat_id,msg_id,"خليكي عانس ؟؟", 'md', false)
end
end

if Text and Text:match('(.*)/zwag_yes/(.*)/mahr/(.*)') then
local Data = {Text:match('(.*)/zwag_yes/(.*)/mahr/(.*)')}
if tonumber(Data[1]) ~= tonumber(user_id) then
return bot.answerCallbackQuery(data.id, "شو رأيك نزوجك بدالهم ؟", true)
end
if tonumber(user_id) == tonumber(Data[1]) then
if redis:get(bot_id.."zwag_request:"..Data[1]) then
local zwga_id = tonumber(Data[1])
local zwg_id = tonumber(Data[2])
local coniss = Data[3]
local zwg = bot.getUser(zwg_id)
local zwga = bot.getUser(zwga_id)
local zwg_tag = '['..zwg.first_name.."](tg://user?id="..zwg_id..")"
local zwga_tag = '['..zwga.first_name.."](tg://user?id="..zwga_id..")"
local hadddd = tonumber(coniss)
ballanceekk = tonumber(coniss) / 100 * 15
ballanceekkk = tonumber(coniss) - ballanceekk
local convert_mony = string.format("%.0f",ballanceekkk)
ballancee = redis:get(bot_id.."boob"..zwg_id) or 0
ballanceea = redis:get(bot_id.."boob"..zwga_id) or 0
zogtea = ballanceea + ballanceekkk
zeugh = ballancee - tonumber(coniss)
redis:set(bot_id.."boob"..zwg_id , math.floor(zeugh))
redis:sadd(bot_id.."roogg1",zwg_id)
redis:sadd(bot_id.."roogga1",zwga_id)
redis:set(bot_id.."roog1"..zwg_id,zwg_id)
redis:set(bot_id.."rooga1"..zwg_id,zwga_id)
redis:set(bot_id.."roogte1"..zwga_id,zwga_id)
redis:set(bot_id.."rahr1"..zwg_id,tonumber(coniss))
redis:set(bot_id.."rahr1"..zwga_id,tonumber(coniss))
redis:set(bot_id.."roog1"..zwga_id,zwg_id)
redis:set(bot_id.."rahrr1"..zwg_id,math.floor(ballanceekkk))
redis:set(bot_id.."rooga1"..zwga_id,zwga_id)
redis:set(bot_id.."rahrr1"..zwga_id,math.floor(ballanceekkk))
return bot.editMessageText(chat_id,msg_id,"كولولولولويششش\nاليوم عقدنا قران :\n\nالزوج "..zwg_tag.." 🤵🏻\n   💗\nالزوجة "..zwga_tag.." 👰🏻‍♀️\nالمهر : "..convert_mony.." دينار بعد الضريبة 15%\nعشان تشوفون وثيقة زواجكم اكتبوا : زواجي", 'md', false)
else
return bot.editMessageText(chat_id,msg_id,"انتهى الطلب وين كنتي لما طلب ايدك", 'md', false)
end
end
end
if Text and Text:match('(%d+)/zwag_no/(%d+)') then
local UserId = {Text:match('(%d+)/zwag_no/(%d+)')}
if tonumber(UserId[1]) ~= tonumber(user_id) then
return bot.answerCallbackQuery(data.id, "شو رأيك نزوجك بدالهم ؟", true)
else
redis:del(bot_id.."zwag_request:"..UserId[1])
redis:del(bot_id.."zwag_request:"..UserId[2])
return bot.editMessageText(chat_id,msg_id,"خليكي عانس ؟؟", 'md', false)
end
end
----
if Text and Text:match('(%d+)/company_yes/(%d+)') then
local Data = {Text:match('(%d+)/company_yes/(%d+)')}
if tonumber(Data[1]) ~= tonumber(user_id) then
return bot.answerCallbackQuery(data.id, "الطلب ليس لك", true)
end
if tonumber(user_id) == tonumber(Data[1]) then
if redis:get(bot_id.."company_request:"..Data[1]) then
local Cname = redis:get(bot_id.."companys_name:"..Data[2])
redis:sadd(bot_id.."company:mem:"..Cname, user_id)
redis:sadd(bot_id.."in_company:", user_id)
redis:set(bot_id.."in_company:name:"..user_id, Cname)
local mem_tag = "["..bot.getUser(user_id).first_name.."](tg://user?id="..user_id..")"
bot.sendText(Data[2],0, "اللاعب "..mem_tag.." وافق على الانضمام الى شركتك","md",true)
return bot.editMessageText(chat_id,msg_id,"تم قبول الطلب بنجاح",'md',false)
else
return bot.editMessageText(chat_id,msg_id,"انتهى الطلب للاسف", 'md', false)
end
end
end
if Text and Text:match('(%d+)/company_no/(%d+)') then
local UserId = {Text:match('(%d+)/company_no/(%d+)')}
if tonumber(UserId[1]) ~= tonumber(user_id) then
return bot.answerCallbackQuery(data.id, "الطلب ليس لك", true)
else
redis:del(bot_id.."company_request:"..UserId[1])
local mem_tag = "["..bot.getUser(user_id).first_name.."](tg://user?id="..user_id..")"
bot.sendText(Data[2],0, "اللاعب "..mem_tag.." رفض العمل في شركتك","md",true)
return bot.editMessageText(chat_id,msg_id,"تم رفض الطلب بنجاح", 'md', false)
end
end
----
if Text and Text:match('(%d+)/UnKed') then
    local UserId = Text:match('(%d+)/UnKed')
    if tonumber(UserId) ~= tonumber(user_id) then
    return bot.answerCallbackQuery(data.id, "⤈︙ عذراً الامر لا يخصك", true)
    end
    bot.setChatMemberStatus(chat_id,user_id,'restricted',{1,1,1,1,1,1,1,1})
    return bot.editMessageText(chat_id,msg_id,"⤈︙ تم التحقق منك يمكنك الدردشة الان", 'md', false)
    end
if Text and Text:match('/leftgroup@(.*)') then
local UserId = Text:match('/leftgroup@(.*)')
bot.answerCallbackQuery(data.id, "⤈︙ تم مغادره البوت من الكروب", true)
bot.leaveChat(UserId)
end
if Text and Text:match('(%d+)/cancelamr') then
local UserId = Text:match('(%d+)/cancelamr')
if tonumber(user_id) == tonumber(UserId) then
redis:del(bot_id.."Command:Reids:Group:Del"..chat_id..":"..user_id)
redis:del(bot_id.."Command:Reids:Group"..chat_id..":"..user_id)
redis:del(bot_id.."Command:Reids:Group:Del"..chat_id..":"..user_id)
redis:del(bot_id.."Command:Reids:Group"..chat_id..":"..user_id)
redis:del(bot_id.."Set:Manager:rd"..user_id..":"..chat_id)
redis:del(bot_id.."Set:Manager:rd:inline"..user_id..":"..chat_id)
redis:del(bot_id.."Zepra:Set:Rd"..user_id..":"..chat_id)
redis:del(bot_id.."Zepra:Set:On"..user_id..":"..chat_id)
redis:del(bot_id..":"..chat_id..":"..user_id..":Command:")
redis:del(bot_id..":"..chat_id..":"..user_id..":Command:del")
redis:del(bot_id..":"..chat_id..":"..user_id..":Command:set")
redis:del(bot_id..":"..chat_id..":"..user_id..":Commandd:sett")
redis:del(bot_id..":"..chat_id..":"..user_id..":id:add")
redis:del(bot_id..":"..chat_id..":"..user_id..":Rp:set")
redis:del(bot_id..":"..chat_id..":"..user_id..":Rp:Text:rd")
redis:del(bot_id..":"..chat_id..":"..user_id..":Rp:del")
redis:del(bot_id..":"..chat_id..":"..user_id..":link:add")
redis:del(bot_id..":"..chat_id..":"..user_id..":we:add")
return bot.editMessageText(chat_id,msg_id,"⤈︙ تم الغاء الامر بنجاح .", 'md')
end
end

if Text and Text:match('(%d+)dl/(.*)') then
local xd = {Text:match('(%d+)dl/(.*)')}
local UserId = xd[1]
local id = xd[2]
if tonumber(data.sender_user_id) == tonumber(UserId) then
local get = io.popen('curl -s "https://globaloneshot.site/video_info.php?id=http://www.youtube.com/watch?v='..id..'"'):read('*a')
local json = json:decode(get)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'تحميل صوت', data = data.sender_user_id..'sound/'..id}, {text = 'تحميل فيديو', data = data.sender_user_id..'video/'..id}, 
},
{
{text = ' ‹ Source Time › ⁦ ', url = 't.me/YAYYYYYY'},
},
}
}
local txx = "["..json.title.."](http://youtu.be/"..id..""
bot.editMessageText(chat_id,msg_id,txx, 'md', true, false, reply_markup)
else
bot.answerCallbackQuery(data.id, "⤈︙ هذا عذراً الامر لا يخصك ", true)
end
end
if Text and Text:match('(%d+)sound/(.*)') then
local xd = {Text:match('(%d+)sound/(.*)')}
local UserId = xd[1]
local id = xd[2]
if tonumber(data.sender_user_id) == tonumber(UserId) then
local u = bot.getUser(data.sender_user_id)
local get = io.popen('curl -s "https://globaloneshot.site/video_info.php?id=http://www.youtube.com/watch?v='..id..'"'):read('*a')
local json = json:decode(get)
local link = "http://www.youtube.com/watch?v="..id
local title = json.title
local title = title:gsub("/","-") 
local title = title:gsub("\n","-") 
local title = title:gsub("|","-") 
local title = title:gsub("'","-") 
local title = title:gsub('"',"-") 
local time = json.t
local p = json.a
local p = p:gsub("/","-") 
local p = p:gsub("\n","-") 
local p = p:gsub("|","-") 
local p = p:gsub("'","-") 
local p = p:gsub('"',"-") 
bot.deleteMessages(chat_id,{[1]= msg_id})
os.execute("yt-dlp "..link.." -f 251 -o '"..title..".mp3'")
bot.sendAudio(chat_id,0,'./'..title..'.mp3',"⤈︙ ["..title.."]("..link..")\n⤈︙ بواسطة ["..u.first_name.."](tg://user?id="..data.sender_user_id..") \n[@YAYYYYYY]","md",tostring(time),title,p) 
sleep(2)
os.remove(""..title..".mp3")
else
bot.answerCallbackQuery(data.id, "⤈︙ هذا عذراً الامر لا يخصك ", true)
end
end
if Text and Text:match('(%d+)video/(.*)') then
local xd = {Text:match('(%d+)video/(.*)')}
local UserId = xd[1]
local id = xd[2]
if tonumber(data.sender_user_id) == tonumber(UserId) then
local u = bot.getUser(data.sender_user_id)
local get = io.popen('curl -s "https://globaloneshot.site/video_info.php?id=http://www.youtube.com/watch?v='..id..'"'):read('*a')
local json = json:decode(get)
local link = "http://www.youtube.com/watch?v="..id
local title = json.title
local title = title:gsub("/","-") 
local title = title:gsub("\n","-") 
local title = title:gsub("|","-") 
local title = title:gsub("'","-") 
local title = title:gsub('"',"-") 
bot.deleteMessages(chat_id,{[1]= msg_id})
os.execute("yt-dlp "..link.." -f 18 -o '"..title..".mp4'")
bot.sendVideo(chat_id,0,'./'..title..'.mp4',"⤈︙ ["..title.."]("..link..")\n⤈︙ بواسطة ["..u.first_name.."](tg://user?id="..data.sender_user_id..") \n[@YAYYYYYY]","md") 
sleep(4)
os.remove(""..title..".mp4")
else
bot.answerCallbackQuery(data.id, "⤈︙ هذا عذراً الامر لا يخصك ", true)
end
end

if Text and Text:match('(%d+)/rewrrt') then
local UserId = Text:match('(%d+)/rewrrt')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,140);
local Text ='⤈︙ تم اختيار الاغنيه لك .'
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '‹ NeXt ↻ ›', callback_data =data.sender_user_id..'/rewrrt'}, 
},
{
{text = ' ‹ Source Time › ⁦ ', url = "https://t.me/YAYYYYYY"}
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. chat_id .. '&voice=https://t.me/rewrrt/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

if Text and Text:match('(%d+)/rrurrw') then
local UserId = Text:match('(%d+)/rrurrw')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,140);
local Text ='⤈︙ تم اختيار القران لك .'
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '‹ NeXt ↻ ›', callback_data =data.sender_user_id..'/rrurrw'}, 
},
{
{text = ' ‹ Source Time › ⁦ ', url = "https://t.me/YAYYYYYY"},
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. chat_id .. '&voice=https://t.me/rrurrw/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

if Text and Text:match('(%d+)/redatw') then
local UserId = Text:match('(%d+)/redatw')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,140);
local Text ='⤈︙ تم اختيار الراب لك .'
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '‹ راب اخر ›', callback_data =data.sender_user_id..'/redatw'}, 
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. chat_id .. '&voice=https://t.me/redatw/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end
-----------------------------------------------
if Text and Text:match('(%d+)/srckt') then
local UserId = Text:match('(%d+)/srckt')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,40);
local Text ='⤈︙ تم اختيار الكت لك .'
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '‹ كت اخر ›', callback_data =data.sender_user_id..'/srckt'}, 
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. chat_id .. '&photo=https://t.me/srckt/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end


--------------------------------------------
if Text and Text:match('(%d+)/aftar') then
local UserId = Text:match('(%d+)/aftar')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,140);
local Text ='⤈︙ تم اختيار الصوره لك .'
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '‹ صوره اخرى ›', callback_data =data.sender_user_id..'/aftar'}, 
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. chat_id .. '&photo=https://t.me/nyx441/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

if Text and Text:match('(%d+)/mmez4') then
local UserId = Text:match('(%d+)/mmez4')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,140);
local Text ='⤈︙ تم اختيار الميمز لك .'
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '‹ NeXt ↻ ›', callback_data =data.sender_user_id..'/mmez4'}, 
},
{
{text = ' ‹ Source Time › ⁦ ', url = "https://t.me/YAYYYYYY"},
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. chat_id .. '&voice=https://t.me/mmez4/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

if Text and Text:match('(%d+)/aftboy') then
local UserId = Text:match('(%d+)/aftboy')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,140);
local Text ='⤈︙ تم اختيار الصوره لك .'
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '‹ صوره اخرى ›', callback_data =data.sender_user_id..'/aftboy'}, 
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. chat_id .. '&photo=https://t.me/avboytol/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

if Text and Text:match('(%d+)/aftgir') then
local UserId = Text:match('(%d+)/aftgir')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,140);
local Text ='⤈︙ تم اختيار الصوره لك .'
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '‹ صوره اخرى ›', callback_data =data.sender_user_id..'/aftgir'}, 
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. chat_id .. '&photo=https://t.me/QXXX_4/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

if Text and Text:match('(%d+)/gifed') then
local UserId = Text:match('(%d+)/gifed')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,140);
local Text ='⤈︙ تم اختيار المتحركه لك .'
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '‹ متحركه اخرى ›', callback_data =data.sender_user_id..'/gifed'}, 
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendanimation?chat_id=' .. chat_id .. '&animation=https://t.me/qwqwgif/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

if Text and Text:match('(%d+)/fillm') then
local UserId = Text:match('(%d+)/fillm')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,140);
local Text ='⤈︙ تم اختيار الفلم لك .'
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '‹ فلم اخر ›', callback_data =data.sender_user_id..'/fillm'}, 
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. chat_id .. '&photo=https://t.me/RRRRRTQ/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

if Text and Text:match('(%d+)/anme') then
local UserId = Text:match('(%d+)/anme')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,140);
local Text ='⤈︙ تم اختيار الانمي لك .'
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '‹ انمي اخر ›', callback_data =data.sender_user_id..'/anme'}, 
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. chat_id .. '&photo=https://t.me/anmee344/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

if Text and Text:match('(%d+)/stor') then
local UserId = Text:match('(%d+)/stor')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,140);
local Text ='⤈︙ تم اختيار الاستوري لك .'
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '‹ ستوري اخر ›', callback_data =data.sender_user_id..'/stor'}, 
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendanimation?chat_id=' .. chat_id .. '&animation=https://t.me/stortolen/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

if Text and Text:match('(%d+)/remix') then
local UserId = Text:match('(%d+)/remix')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,140);
local Text ='⤈︙ تم اختيار الريمكس لك .'
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '‹ NeXt ↻ ›', callback_data =data.sender_user_id..'/remix'}, 
},
{
{text = ' ‹ Source Time › ⁦ ', url = "https://t.me/YAYYYYYY"},
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. chat_id .. '&voice=https://t.me/remix/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

if Text and Text:match('(%d+)/sherru2') then
local UserId = Text:match('(%d+)/sherru2')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,140);
local Text ='⤈︙ تم اختيار الشعر لك .'
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '‹ NeXt ↻ ›', callback_data =data.sender_user_id..'/sherru2'}, 
},
{
{text = ' ‹ Source Time › ⁦ ', url = "https://t.me/YAYYYYYY"},
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. chat_id .. '&voice=https://t.me/sherru2/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end
----
if Text and Text:match("^(%d+)Getprj(.*)$") then
local notId  = Text:match("(%d+)")  
local OnID = Text:gsub('Getprj',''):gsub(notId,'')
if tonumber(data.sender_user_id) ~= tonumber(notId) then  
return bot.answerCallbackQuery(data.id,"⤈︙ عذراً الامر لا يخصك ", true)
end
u , res = https.request('https://black-source.xyz/BlackTeAM/Horoscopes.php?br='..OnID)
JsonSInfo = JSON.decode(u)
InfoGet = JsonSInfo['result']['info']
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "‹ برج الجوزاء ›",data=data.sender_user_id.."Getprjالجوزاء"},{text ="‹ برج الثور ›",data=data.sender_user_id.."Getprjالثور"},{text ="‹ برج الحمل ›",data=data.sender_user_id.."Getprjالحمل"}},
{{text = "‹ برج العذراء ›",data=data.sender_user_id.."Getprjالعذراء"},{text ="‹ برج الاسد ›",data=data.sender_user_id.."Getprjالاسد"},{text ="‹ برج السرطان ›",data=data.sender_user_id.."Getprjالسرطان"}},
{{text = "‹ برج القوس ›",data=data.sender_user_id.."Getprjالقوس"},{text ="‹ برج العقرب ›",data=data.sender_user_id.."Getprjالعقرب"},{text ="‹ برج الميزان ›",data=data.sender_user_id.."Getprjالميزان"}},
{{text = "‹ برج الحوت ›",data=data.sender_user_id.."Getprjالحوت"},{text ="‹ برج الدلو ›",data=data.sender_user_id.."Getprjالدلو"},{text ="‹ برج الجدي ›",data=data.sender_user_id.."Getprjالجدي"}},
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
bot.editMessageText(chat_id,msg_id,InfoGet, 'md', true, false, reply_markup)
end
if Text and Text:match("^"..data.sender_user_id.."yfc_(.*)") then
local vr  = Text:match("^yfc_(.*)")
 reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الروابط'" ,data="donerout_"..data.sender_user_id.."_Links_"..vr},{text =Gdone(chat_id,vr,"Links") ,data="donerout_"..data.sender_user_id.."_Links_"..vr}},
{{text = "'التوجيه'" ,data="donerout_"..data.sender_user_id.."_forwardinfo_"..vr},{text =Gdone(chat_id,vr,"forwardinfo"),data="donerout_"..data.sender_user_id.."_forwardinfo_"..vr}},
{{text = "'التعديل'" ,data="donerout_"..data.sender_user_id.."_Edited_"..vr},{text =Gdone(chat_id,vr,"Edited"),data="donerout_"..data.sender_user_id.."_Edited_"..vr}},
{{text = "'الجهات'" ,data="donerout_"..data.sender_user_id.."_messageContact_"..vr},{text =Gdone(chat_id,vr,"messageContact"),data="donerout_"..data.sender_user_id.."_messageContact_"..vr}},
{{text = "'الصور'" ,data="donerout_"..data.sender_user_id.."_messagePhoto_"..vr},{text =Gdone(chat_id,vr,"messagePhoto"),data="donerout_"..data.sender_user_id.."_messagePhoto_"..vr}},
{{text = "'الفيديو'" ,data="donerout_"..data.sender_user_id.."_messageVideo_"..vr},{text =Gdone(chat_id,vr,"messageVideo"),data="donerout_"..data.sender_user_id.."_messageVideo_"..vr}},
{{text = "'المتحركات'" ,data="donerout_"..data.sender_user_id.."_messageAnimation_"..vr},{text =Gdone(chat_id,vr,"messageAnimation"),data="donerout_"..data.sender_user_id.."_messageAnimation_"..vr}},
{{text = "'الملصقات'" ,data="donerout_"..data.sender_user_id.."_messageSticker_"..vr},{text =Gdone(chat_id,vr,"messageSticker"),data="donerout_"..data.sender_user_id.."_messageSticker_"..vr}},
{{text = "'الملفات'" ,data="donerout_"..data.sender_user_id.."_messageDocument_"..vr},{text =Gdone(chat_id,vr,"messageDocument"),data="donerout_"..data.sender_user_id.."_messageDocument_"..vr}},
}
}
bot.editMessageText(chat_id,msg_id,"- قم باختيار ما تريد تقييده عن ( "..Reply_Status(vr).user.."؛)", 'md', true, false, reply_markup)
end
if Text and Text:match("^donerout_(.*)_(.*)_(.*)") then
local infomsg = {Text:match("^donerout_(.*)_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "⤈︙ عذراً الامر لا يخصك  .", true)
return false
end
vr = infomsg[3]
if redis:get(bot_id..":"..chat_id..":"..infomsg[2]..":RankrestrictionGdone:"..vr) then
redis:del(bot_id..":"..chat_id..":"..infomsg[2]..":RankrestrictionGdone:"..vr)
else
redis:set(bot_id..":"..chat_id..":"..infomsg[2]..":RankrestrictionGdone:"..vr,true)
end
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الروابط'" ,data="donerout_"..data.sender_user_id.."_Links_"..vr},{text =Gdone(chat_id,vr,"Links") ,data="donerout_"..data.sender_user_id.."_Links_"..vr}},
{{text = "'التوجيه'" ,data="donerout_"..data.sender_user_id.."_forwardinfo_"..vr},{text =Gdone(chat_id,vr,"forwardinfo"),data="donerout_"..data.sender_user_id.."_forwardinfo_"..vr}},
{{text = "'التعديل'" ,data="donerout_"..data.sender_user_id.."_Edited_"..vr},{text =Gdone(chat_id,vr,"Edited"),data="donerout_"..data.sender_user_id.."_Edited_"..vr}},
{{text = "'الجهات'" ,data="donerout_"..data.sender_user_id.."_messageContact_"..vr},{text =Gdone(chat_id,vr,"messageContact"),data="donerout_"..data.sender_user_id.."_messageContact_"..vr}},
{{text = "'الصور'" ,data="donerout_"..data.sender_user_id.."_messagePhoto_"..vr},{text =Gdone(chat_id,vr,"messagePhoto"),data="donerout_"..data.sender_user_id.."_messagePhoto_"..vr}},
{{text = "'الفيديو'" ,data="donerout_"..data.sender_user_id.."_messageVideo_"..vr},{text =Gdone(chat_id,vr,"messageVideo"),data="donerout_"..data.sender_user_id.."_messageVideo_"..vr}},
{{text = "'المتحركات'" ,data="donerout_"..data.sender_user_id.."_messageAnimation_"..vr},{text =Gdone(chat_id,vr,"messageAnimation"),data="donerout_"..data.sender_user_id.."_messageAnimation_"..vr}},
{{text = "'الملصقات'" ,data="donerout_"..data.sender_user_id.."_messageSticker_"..vr},{text =Gdone(chat_id,vr,"messageSticker"),data="donerout_"..data.sender_user_id.."_messageSticker_"..vr}},
{{text = "'الملفات'" ,data="donerout_"..data.sender_user_id.."_messageDocument_"..vr},{text =Gdone(chat_id,vr,"messageDocument"),data="donerout_"..data.sender_user_id.."_messageDocument_"..vr}},
{{text = "‹ اخفاء ›" ,data="Rdel_"..data.sender_user_id.."_Rdel"}},
}
}
bot.editMessageText(chat_id,msg_id,"- قم باختيار ما تريد تقييده عن ( "..Reply_Status(vr,"").user.."؛)", 'md', true, false, reply_markup)
end
----
if Text and Text:match("^Punishment_(.*)_(.*)_(.*)") then
local infomsg = {Text:match("^Punishment_(.*)_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "⤈︙ الامر لا بخصك .", true)
return false
end
if infomsg[3] == "bn" then
local UserInfo = bot.getUser(infomsg[2])
if GetInfoBot(data).BanUser == false then
thetxt = '*⤈︙ البوت لا يمتلك صلاحيه حظر الاعضاء .* '
end
if not Norank(infomsg[2],chat_id) then
thetxt = "*⤈︙ لا يمكنك حظر "..Get_Rank(infomsg[2],chat_id).." .*"
else
thetxt = "*⤈︙ تم حظره بنجاح .*"
tkss = bot.setChatMemberStatus(chat_id,infomsg[2],'banned',0)
redis:sadd(bot_id..":"..chat_id..":Ban",infomsg[2])
if tkss.luatele == "error" then
thetxt = "*⤈︙  لا يمكن حظر المستخدم  .*"
end
end
thetxt = Reply_Status(infomsg[2],thetxt).i
elseif infomsg[3] == "unbn" then
thetxt = Reply_Status(infomsg[2],"*⤈︙ تم الغاء حظره بنجاح .*").i
redis:srem(bot_id..":"..chat_id..":Ban",infomsg[2])
bot.setChatMemberStatus(chat_id,infomsg[2],'restricted',{1,1,1,1,1,1,1,1,1})
elseif infomsg[3] == "kik" then
if GetInfoBot(data).BanUser == false then
thetxt = '*⤈︙ البوت لا يمتلك صلاحيه طرد الاعضاء .* '
end
if not Norank(infomsg[2],chat_id) then
thetxt = "*⤈︙ لا يمكنك طرد "..Get_Rank(infomsg[2],chat_id).." .*"
else
thetxt = "*⤈︙ تم طرده بنجاح .*"
tkss = bot.setChatMemberStatus(chat_id,infomsg[2],'banned',0)
if tkss.luatele == "error" then
thetxt = "*⤈︙   لا يمكن طرد المستخدم  .*"
end
end
thetxt = Reply_Status(infomsg[2],thetxt).i
elseif infomsg[3] == "ktm" then
if not Norank(infomsg[2],chat_id) then
thetxt = "*⤈︙ لا يمكنك كتم "..Get_Rank(infomsg[2],chat_id).." .*"
else
thetxt = "*⤈︙ تم كتمه بنجاح .*"
redis:sadd(bot_id..":"..chat_id..":silent",infomsg[2])
end
thetxt = Reply_Status(infomsg[2],thetxt).i
elseif infomsg[3] == "unktm" then
thetxt = "*⤈︙ تم الغاء كتمه بنجاح .*"
redis:srem(bot_id..":"..chat_id..":silent",infomsg[2])
thetxt = Reply_Status(infomsg[2],thetxt).i
elseif infomsg[3] == "ked" then
if GetInfoBot(data).BanUser == false then
thetxt = '*⤈︙ البوت لا يمتلك صلاحيه تقييد الاعضاء .* '
end
if not Norank(infomsg[2],chat_id) then
thetxt = "*⤈︙ لا يمكنك تقييد "..Get_Rank(infomsg[2],chat_id).." .*"
else
thetxt = "*⤈︙ تم تقييده بنجاح .*"
tkss = bot.setChatMemberStatus(chat_id,infomsg[2],'restricted',{1,0,0,0,0,0,0,0,0})
if tkss.luatele == "error" then
thetxt = "*⤈︙   لا يمكن تقييد المستخدم  .*"
end
redis:sadd(bot_id..":"..chat_id..":restrict",infomsg[2])
end
thetxt = Reply_Status(infomsg[2],thetxt).i
elseif infomsg[3] == "unked" then
thetxt = "*⤈︙ تم الغاء تقييده بنجاح .*"
redis:srem(bot_id..":"..chat_id..":restrict",infomsg[2])
thetxt = Reply_Status(infomsg[2],thetxt).i
bot.setChatMemberStatus(chat_id,infomsg[2],'restricted',{1,1,1,1,1,1,1,1,1})
end
bot.editMessageText(chat_id,msg_id,thetxt, 'md', true, false, reply_markup)
end
if Text and Text:match("^infoment_(.*)_(.*)_(.*)") then
local infomsg = {Text:match("^infoment_(.*)_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "- الامر لا بخصك .", true)
return false
end  
if infomsg[3] == "GetRank" then
thetxt = "*⤈︙ رتبته : *( `"..(Get_Rank(infomsg[2],chat_id)).."` *)*"
elseif infomsg[3] == "message" then
thetxt = "*⤈︙ عدد رسائله : *( `"..(redis:get(bot_id..":"..chat_id..":"..infomsg[2]..":message") or 1).."` *)*"
elseif infomsg[3] == "Editmessage" then
thetxt = "*⤈︙ عدد سحكاته : *( `"..(redis:get(bot_id..":"..chat_id..":"..infomsg[2]..":Editmessage") or 0).."` *)*"
elseif infomsg[3] == "game" then
thetxt = "*⤈︙ عدد نقاطه : *( `"..(redis:get(bot_id..":"..chat_id..":"..infomsg[2]..":game") or 0).."` *)*"
elseif infomsg[3] == "Addedmem" then
thetxt = "*⤈︙ عدد جهاته : *( `"..(redis:get(bot_id..":"..chat_id..":"..infomsg[2]..":Addedmem") or 0).."` *)*"
elseif infomsg[3] == "addme" then
if bot.getChatMember(chat_id,infomsg[2]).status.luatele == "chatMemberStatusCreator" then
thetxt =  "*⤈︙ هو منشئ المجموعه. *"
else
addby = redis:get(bot_id..":"..chat_id..":"..infomsg[2]..":AddedMe")
if addby then 
UserInfo = bot.getUser(addby)
Name = '['..UserInfo.first_name..'](tg://user?id='..addby..')'
thetxt = "*⤈︙ تم اضافته بواسطه  : ( *"..(Name).." *)*"
else
thetxt = "*⤈︙ قد انضم الى المجموعه عبر الرابط .*"
end
end
end
bot.editMessageText(chat_id,msg_id,thetxt, 'md', true, false, reply_markup)
end
if Text and Text:match("^promotion_(.*)_(.*)_(.*)") then
local infomsg = {Text:match("^promotion_(.*)_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "⤈︙ الامر لا بخصك .", true)
return false
end   
thetxt = "*⤈︙ قسم الرفع والتنزيل .\n⤈︙ العلامه ( ✅️ ) تعني الشخص يمتلك الرتبه .\n⤈︙ العلامه ( ❌️ ) تعني الشخص لا يمتلك الرتبه .*"
addStatu(infomsg[3],infomsg[2],chat_id)
if devB(data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'مطور ثانوي'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_programmer"},{text =IsStatu("programmer",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_programmer"}},
{{text = "'مطور'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_developer"},{text =IsStatu("developer",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_developer"}},
{{text = "'مالك'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"},{text =IsStatu("Creator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"}},
{{text = "'منشى اساسي'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"},{text =IsStatu("BasicConstructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"}},
{{text = "'منشئ'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"},{text =IsStatu("Constructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"}},
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":Status:Basic",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'مطور ثانوي'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_programmer"},{text =IsStatu("programmer",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_programmer"}},
{{text = "'مطور'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_developer"},{text =IsStatu("developer",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_developer"}},
{{text = "'مالك'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"},{text =IsStatu("Creator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"}},
{{text = "'منشى اساسي'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"},{text =IsStatu("BasicConstructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"}},
{{text = "'منشئ'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"},{text =IsStatu("Constructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"}},
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":Status:programmer",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'مطور'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_developer"},{text =IsStatu("developer",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_developer"}},
{{text = "'مالك'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"},{text =IsStatu("Creator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"}},
{{text = "'منشى اساسي'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"},{text =IsStatu("BasicConstructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"}},
{{text = "'منشئ'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"},{text =IsStatu("Constructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"}},
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":Status:developer",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'مالك'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"},{text =IsStatu("Creator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"}},
{{text = "'منشى اساسي'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"},{text =IsStatu("BasicConstructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"}},
{{text = "'منشئ'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"},{text =IsStatu("Constructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"}},
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":"..chat_id..":Status:Creator",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'منشى اساسي'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"},{text =IsStatu("BasicConstructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"}},
{{text = "'منشئ'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"},{text =IsStatu("Constructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"}},
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'منشئ'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"},{text =IsStatu("Constructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"}},
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "??" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":"..chat_id..":Status:Constructor",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":"..chat_id..":Status:Owner",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":"..chat_id..":Status:Administrator",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
end
bot.editMessageText(chat_id,msg_id,thetxt, 'md', true, false, reply_markup)
end
if Text and Text:match("^"..data.sender_user_id.."_(.*)bkthk") then
local infomsg = {Text:match("^"..data.sender_user_id.."_(.*)bkthk")}
thetxt = "*⤈︙ اختر الامر المناسب*"
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text ="قائمه 'الرفع و التنزيل'",data="control_"..data.sender_user_id.."_"..infomsg[1].."_1"}},
{{text ="قائمه 'العقوبات'",data="control_"..data.sender_user_id.."_"..infomsg[1].."_2"}},
{{text = "كشف 'المعلومات'" ,data="control_"..data.sender_user_id.."_"..infomsg[1].."_3"}},
}
}
bot.editMessageText(chat_id,msg_id,thetxt, 'md', true, false, reply_markup)
end
if Text and Text:match("^control_(.*)_(.*)_(.*)") then
local infomsg = {Text:match("^control_(.*)_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "⤈︙ الامر لا بخصك .", true)
return false
end   
if tonumber(infomsg[3]) == 1 then
thetxt = "*⤈︙ قسم الرفع والتنزيل . \n⤈︙ العلامه ( ✅️ ) تعني الشخص يمتلك الرتبه .\n⤈︙ العلامه ( ❌️ ) تعني الشخص لا يمتلك الرتبه .*"
if devB(data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'مطور ثانوي'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_programmer"},{text =IsStatu("programmer",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_programmer"}},
{{text = "'مطور'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_developer"},{text =IsStatu("developer",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_developer"}},
{{text = "'مالك'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"},{text =IsStatu("Creator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"}},
{{text = "'منشى اساسي'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"},{text =IsStatu("BasicConstructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"}},
{{text = "'منشئ'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"},{text =IsStatu("Constructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"}},
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":Status:Basic",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'مطور ثانوي'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_programmer"},{text =IsStatu("programmer",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_programmer"}},
{{text = "'مطور'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_developer"},{text =IsStatu("developer",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_developer"}},
{{text = "'مالك'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"},{text =IsStatu("Creator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"}},
{{text = "'منشى اساسي'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"},{text =IsStatu("BasicConstructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"}},
{{text = "'منشئ'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"},{text =IsStatu("Constructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"}},
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":Status:programmer",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'مطور'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_developer"},{text =IsStatu("developer",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_developer"}},
{{text = "'مالك'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"},{text =IsStatu("Creator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"}},
{{text = "'منشى اساسي'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"},{text =IsStatu("BasicConstructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"}},
{{text = "'منشئ'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"},{text =IsStatu("Constructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"}},
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":Status:developer",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'مالك'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"},{text =IsStatu("Creator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"}},
{{text = "'منشى اساسي'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"},{text =IsStatu("BasicConstructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"}},
{{text = "'منشئ'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"},{text =IsStatu("Constructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"}},
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":"..chat_id..":Status:Creator",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'منشى اساسي'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"},{text =IsStatu("BasicConstructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"}},
{{text = "'منشئ'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"},{text =IsStatu("Constructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"}},
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'منشئ'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"},{text =IsStatu("Constructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"}},
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":"..chat_id..":Status:Constructor",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":"..chat_id..":Status:Owner",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":"..chat_id..":Status:Administrator",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
end
elseif  infomsg[3] == "2" then
thetxt = "*⤈︙ قم بأختيار العقوبه الان .*"
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'حظر'" ,data="Punishment_"..data.sender_user_id.."_"..infomsg[2].."_bn"},{text = "'الغاء حظر'" ,data="Punishment_"..data.sender_user_id.."_"..infomsg[2].."_unbn"}},
{{text = "'طرد'" ,data="Punishment_"..data.sender_user_id.."_"..infomsg[2].."_kik"}},
{{text = "'تقييد'" ,data="Punishment_"..data.sender_user_id.."_"..infomsg[2].."_ked"},{text = "'الغاء تقييد'" ,data="Punishment_"..data.sender_user_id.."_"..infomsg[2].."_unked"}},
{{text = "'كتم'" ,data="Punishment_"..data.sender_user_id.."_"..infomsg[2].."_ktm"},{text = "'الغاء كتم'" ,data="Punishment_"..data.sender_user_id.."_"..infomsg[2].."_unktm"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif  infomsg[3] == "3" then
local UserInfo = bot.getUser(infomsg[2])
if UserInfo.username and UserInfo.username ~= "" then
us1 = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
else
us1 = '['..UserInfo.first_name..'](tg://user?id='..UserInfo.id..')'
end
thetxt = "*⤈︙ معلومات حول *( "..us1.." )"
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'رتبته'" ,data="infoment_"..data.sender_user_id.."_"..infomsg[2].."_GetRank"}},
{{text = "'رسائله'" ,data="infoment_"..data.sender_user_id.."_"..infomsg[2].."_message"}},
{{text = "'سحكاته'" ,data="infoment_"..data.sender_user_id.."_"..infomsg[2].."_Editmessage"}},
{{text = "'نقاطه'" ,data="infoment_"..data.sender_user_id.."_"..infomsg[2].."_game"}},
{{text = "'جهاته'" ,data="infoment_"..data.sender_user_id.."_"..infomsg[2].."_Addedmem"}},
{{text = "'منو ضافه'" ,data="infoment_"..data.sender_user_id.."_"..infomsg[2].."_addme"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
end
bot.editMessageText(chat_id,msg_id,thetxt, 'md', true, false, reply_markup)
end
----
if Text == data.sender_user_id.."bkt" then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'منشى اساسي'" ,data="changeofvalidity_"..data.sender_user_id.."_5"}},
{{text = "'منشئ'" ,data="changeofvalidity_"..data.sender_user_id.."_4"}},
{{text = "'مدير'" ,data="changeofvalidity_"..data.sender_user_id.."_3"}},
{{text = "'ادمن'" ,data="changeofvalidity_"..data.sender_user_id.."_2"}},
{{text = "'مميز'" ,data="changeofvalidity_"..data.sender_user_id.."_1"}},
}
}
bot.editMessageText(chat_id,msg_id,"*⤈︙ قم بأختيار الرتبه التي تريد تققيد محتوى لها*", 'md', true, false, reply_markup)
end
if Text == data.sender_user_id.."bkt" then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'منشى اساسي'" ,data="changeofvalidity_"..data.sender_user_id.."_5"}},
{{text = "'منشئ'" ,data="changeofvalidity_"..data.sender_user_id.."_4"}},
{{text = "'مدير'" ,data="changeofvalidity_"..data.sender_user_id.."_3"}},
{{text = "'ادمن'" ,data="changeofvalidity_"..data.sender_user_id.."_2"}},
{{text = "'مميز'" ,data="changeofvalidity_"..data.sender_user_id.."_1"}},
}
}
bot.editMessageText(chat_id,msg_id,"*⤈︙ قم بأختيار الرتبه التي تريد تققيد محتوى لها*", 'md', true, false, reply_markup)
end
if Text and Text:match("^changeofvalidity_(.*)_(.*)") then
local infomsg = {Text:match("^changeofvalidity_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "⤈︙ الامر لا بخصك .", true)
return false
end   
redis:del(bot_id..":"..data.sender_user_id..":s")
if infomsg[2] == "1" then
rt = "مميز"
vr = "Vips"
elseif infomsg[2] == "2" then
rt = "ادمن"
vr = "Administrator"
elseif infomsg[2] == "3" then
rt = "مدير"
vr = "Owner"
elseif infomsg[2] == "4" then
rt = "منشئ"
vr = "Constructor"
elseif infomsg[2] == "5" then
rt = "منشئ الاساسي"
vr = "BasicConstructor"
end
redis:setex(bot_id..":"..data.sender_user_id..":s",1300,vr)
redis:setex(bot_id..":"..data.sender_user_id..":d",1300,rt)
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الروابط'" ,data="carryout_"..data.sender_user_id.."_Links"},{text =Rankrestriction(chat_id,vr,"Links"),data="carryout_"..data.sender_user_id.."_Links"}},
{{text = "'التوجيه'" ,data="carryout_"..data.sender_user_id.."_forwardinfo"},{text =Rankrestriction(chat_id,vr,"forwardinfo"),data="carryout_"..data.sender_user_id.."_forwardinfo"}},
{{text = "'التعديل'" ,data="carryout_"..data.sender_user_id.."_Edited"},{text =Rankrestriction(chat_id,vr,"Edited"),data="carryout_"..data.sender_user_id.."_Edited"}},
{{text = "'الجهات'" ,data="carryout_"..data.sender_user_id.."_messageContact"},{text =Rankrestriction(chat_id,vr,"messageContact"),data="carryout_"..data.sender_user_id.."_messageContact"}},
{{text = "'الصور'" ,data="carryout_"..data.sender_user_id.."_messagePhoto"},{text =Rankrestriction(chat_id,vr,"messagePhoto"),data="carryout_"..data.sender_user_id.."_messagePhoto"}},
{{text = "'الفيديو'" ,data="carryout_"..data.sender_user_id.."_messageVideo"},{text =Rankrestriction(chat_id,vr,"messageVideo"),data="carryout_"..data.sender_user_id.."_messageVideo"}},
{{text = "'المتحركات'" ,data="carryout_"..data.sender_user_id.."_messageAnimation"},{text =Rankrestriction(chat_id,vr,"messageAnimation"),data="carryout_"..data.sender_user_id.."_messageAnimation"}},
{{text = "'الملصقات'" ,data="carryout_"..data.sender_user_id.."_messageSticker"},{text =Rankrestriction(chat_id,vr,"messageSticker"),data="carryout_"..data.sender_user_id.."_messageSticker"}},
{{text = "'الملفات'" ,data="carryout_"..data.sender_user_id.."_messageDocument"},{text =Rankrestriction(chat_id,vr,"messageDocument"),data="carryout_"..data.sender_user_id.."_messageDocument"}},
{{text = "🔙" ,data=data.sender_user_id.."bkt"}},
}
}
bot.editMessageText(chat_id,msg_id,"⤈︙ قم باختيار ما تريد تقييده عن ( ال"..rt.."؛)", 'md', true, false, reply_markup)
end
if Text and Text:match("^carryout_(.*)_(.*)") then
local infomsg = {Text:match("^carryout_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "⤈︙ الامر لا بخصك .", true)
return false
end
vr = (redis:get(bot_id..":"..data.sender_user_id..":s") or  "Vips")
rt = (redis:get(bot_id..":"..data.sender_user_id..":d") or  "مميز")
redis:setex(bot_id..":"..data.sender_user_id..":s",1300,vr)
redis:setex(bot_id..":"..data.sender_user_id..":d",1300,rt)
if redis:get(bot_id..":"..chat_id..":"..infomsg[2]..":Rankrestriction:"..(redis:get(bot_id..":"..data.sender_user_id..":s") or  "Vips")) then
redis:del(bot_id..":"..chat_id..":"..infomsg[2]..":Rankrestriction:"..vr)
else
redis:set(bot_id..":"..chat_id..":"..infomsg[2]..":Rankrestriction:"..vr,true)
end
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الروابط'" ,data="carryout_"..data.sender_user_id.."_Links"},{text =Rankrestriction(chat_id,vr,"Links") ,data="carryout_"..data.sender_user_id.."_Links"}},
{{text = "'التوجيه'" ,data="carryout_"..data.sender_user_id.."_forwardinfo"},{text =Rankrestriction(chat_id,vr,"forwardinfo"),data="carryout_"..data.sender_user_id.."_forwardinfo"}},
{{text = "'التعديل'" ,data="carryout_"..data.sender_user_id.."_Edited"},{text =Rankrestriction(chat_id,vr,"Edited"),data="carryout_"..data.sender_user_id.."_Edited"}},
{{text = "'الجهات'" ,data="carryout_"..data.sender_user_id.."_messageContact"},{text =Rankrestriction(chat_id,vr,"messageContact"),data="carryout_"..data.sender_user_id.."_messageContact"}},
{{text = "'الصور'" ,data="carryout_"..data.sender_user_id.."_messagePhoto"},{text =Rankrestriction(chat_id,vr,"messagePhoto"),data="carryout_"..data.sender_user_id.."_messagePhoto"}},
{{text = "'الفيديو'" ,data="carryout_"..data.sender_user_id.."_messageVideo"},{text =Rankrestriction(chat_id,vr,"messageVideo"),data="carryout_"..data.sender_user_id.."_messageVideo"}},
{{text = "'المتحركات'" ,data="carryout_"..data.sender_user_id.."_messageAnimation"},{text =Rankrestriction(chat_id,vr,"messageAnimation"),data="carryout_"..data.sender_user_id.."_messageAnimation"}},
{{text = "'الملصقات'" ,data="carryout_"..data.sender_user_id.."_messageSticker"},{text =Rankrestriction(chat_id,vr,"messageSticker"),data="carryout_"..data.sender_user_id.."_messageSticker"}},
{{text = "'الملفات'" ,data="carryout_"..data.sender_user_id.."_messageDocument"},{text =Rankrestriction(chat_id,vr,"messageDocument"),data="carryout_"..data.sender_user_id.."_messageDocument"}},
{{text = "🔙" ,data=data.sender_user_id.."bkt"}},
}
}
bot.editMessageText(chat_id,msg_id,"⤈︙ قم باختيار ما تريد تقييده عن ( ال"..rt.."؛)", 'md', true, false, reply_markup)
end

if Text and Text:match('(%d+)/play_wheel') then
    local UserId = Text:match('(%d+)/play_wheel')
    if tonumber(data.sender_user_id) == tonumber(UserId) and redis:get(bot_id.."happywheel:st:"..UserId..":"..chat_id) then
    redis:del(bot_id.."happywheel:st:"..UserId..":"..chat_id)
    local media = {
      {
        "https://t.me/f_0_C/14","مبروك ربحت 10000000 دينار 💵","10000000"
      },
      {
        "https://t.me/f_0_C/14","مبروك ربحت 5000000 دينار 💵","5000000"
      },
      {
        "https://t.me/f_0_C/14","مبروك ربحت 1000000 دينار 💵","1000000"
      },
      {
        "https://t.me/f_0_C/14","مبروك ربحت 100000 دينار 💵","100000"
      },
      {
        "https://t.me/f_0_C/16","مبروك ربحت 4 قصور","4"
      },
      {
        "https://t.me/f_0_C/15","مبروك ربحت 8 فيلات","8"
      },
      {
        "https://t.me/f_0_C/17","مبروك ربحت 15 منزل","15"
      },
      {
        "https://t.me/f_0_C/20","مبروك ربحت 5 ماسات","5"
      },
      {
        "https://t.me/f_0_C/21","مبروك ربحت 6 قلادات","6"
      },
      {
        "https://t.me/f_0_C/22","مبروك ربحت 10 اساور","10"
      },
      {
        "https://t.me/f_0_C/23","مبروك ربحت 20 خاتم","20"
      },
      {
        "https://t.me/f_0_C/14","مبروك ربحت مضاعفة نصف الفلوس","1"
      },
      {
        "https://t.me/f_0_C/14","مبروك خسرت ربع فلوسك","1"
      },
    }
    local rand = math.random(1,11)
    local msg_media = {
    type = "photo",
    media = media[rand][1],
    caption = media[rand][2],
    parse_mode = "Markdown"                    
    }     
    local keyboard = {} 
    keyboard.inline_keyboard = {
    {
    {text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}, 
    },
    }
    local msg_reply = msg_id/2097152/0.5
ballance = redis:get(bot_id.."boob"..data.sender_user_id) or 0
if rand == 1 then
ballancek = ballance + media[rand][3]
redis:set(bot_id.."boob"..data.sender_user_id , math.floor(ballancek))
elseif rand == 2 then
ballancek = ballance + media[rand][3]
redis:set(bot_id.."boob"..data.sender_user_id , math.floor(ballancek))
elseif rand == 3 then
ballancek = ballance + media[rand][3]
redis:set(bot_id.."boob"..data.sender_user_id , math.floor(ballancek))
elseif rand == 4 then
ballancek = ballance + media[rand][3]
redis:set(bot_id.."boob"..data.sender_user_id , math.floor(ballancek))
elseif rand == 5 then
local akrksrnumm = redis:get(bot_id.."akrksrnum"..data.sender_user_id) or 0
local akrksrnoww = tonumber(akrksrnumm) + media[rand][3]
redis:set(bot_id.."akrksrnum"..data.sender_user_id , math.floor(akrksrnoww))
ksrnamed = "قصر"
redis:set(bot_id.."akrksrname"..data.sender_user_id,ksrnamed)
elseif rand == 6 then
local akrfelnumm = redis:get(bot_id.."akrfelnum"..data.sender_user_id) or 0
local akrfelnoww = tonumber(akrfelnumm) + media[rand][3]
redis:set(bot_id.."akrfelnum"..data.sender_user_id , math.floor(akrfelnoww))
felnamed = "فيلا"
redis:set(bot_id.."akrfelname"..data.sender_user_id,felnamed)
elseif rand == 7 then
local akrmnznumm = redis:get(bot_id.."akrmnznum"..data.sender_user_id) or 0
local akrmnznoww = tonumber(akrmnznumm) + media[rand][3]
redis:set(bot_id.."akrmnznum"..data.sender_user_id , math.floor(akrmnznoww))
mnznamed = "منزل"
redis:set(bot_id.."akrmnzname"..data.sender_user_id,mnznamed)
elseif rand == 8 then
local mgrmasnumm = redis:get(bot_id.."mgrmasnum"..data.sender_user_id) or 0
local mgrmasnoww = tonumber(mgrmasnumm) + media[rand][3]
redis:set(bot_id.."mgrmasnum"..data.sender_user_id , math.floor(mgrmasnoww))
masnamed = "ماسه"
redis:set(bot_id.."mgrmasname"..data.sender_user_id,masnamed)
elseif rand == 9 then
local mgrkldnumm = redis:get(bot_id.."mgrkldnum"..data.sender_user_id) or 0
local mgrkldnoww = tonumber(mgrkldnumm) + media[rand][3]
redis:set(bot_id.."mgrkldnum"..data.sender_user_id , math.floor(mgrkldnoww))
kldnamed = "قلاده"
redis:set(bot_id.."mgrkldname"..data.sender_user_id,kldnamed)
elseif rand == 10 then
local mgrswrnumm = redis:get(bot_id.."mgrswrnum"..data.sender_user_id) or 0
local mgrswrnoww = tonumber(mgrswrnumm) + media[rand][3]
redis:set(bot_id.."mgrswrnum"..data.sender_user_id , math.floor(mgrswrnoww))
swrnamed = "سوار"
redis:set(bot_id.."mgrswrname"..data.sender_user_id,swrnamed)
elseif rand == 11 then
local mgrktmnumm = redis:get(bot_id.."mgrktmnum"..data.sender_user_id) or 0
local mgrktmnoww = tonumber(mgrktmnumm) + media[rand][3]
redis:set(bot_id.."mgrktmnum"..data.sender_user_id , math.floor(mgrktmnoww))
ktmnamed = "خاتم"
redis:set(bot_id.."mgrktmname"..data.sender_user_id,ktmnamed)
elseif rand == 12 then
ballancek = ballance / 2
ballancekk = math.floor(ballancek) + ballance
redis:set(bot_id.."boob"..data.sender_user_id , ballancekk)
else
ballancek = ballance / 4
ballancekk = ballance - math.floor(ballancek)
redis:set(bot_id.."boob"..data.sender_user_id , math.floor(ballancekk))
end
https.request("http://api.telegram.org/bot"..Token.."/editmessagemedia?chat_id="..chat_id.."&message_id="..msg_reply.."&media="..JSON.encode(msg_media).."&reply_markup="..JSON.encode(keyboard))
end 
end

if Text and Text:match('(%d+)/toptop') then
local UserId = Text:match('(%d+)/toptop')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local toptop = "⤈︙  اهلين فيك في قوائم التوب\nللمزيد من التفاصيل - [@YAYYYYYY]\n"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'الزرف', data = data.sender_user_id..'/topzrf'},{text = 'الفلوس', data = data.sender_user_id..'/topmon'},{text = 'زواجات', data = data.sender_user_id..'/zoztee'},
},
{
{text = 'المتبرعين', data = data.sender_user_id..'/motbra'},{text = 'الشركات', data = data.sender_user_id..'/shrkatt'},
},
{
{text = '‹ اخفاء ›', data = data.sender_user_id..'/delAmr'}, 
},
{
{text = ' ‹ Source Time › ⁦ ', url="t.me/YAYYYYYY"},
},
}
}
bot.editMessageText(chat_id,msg_id,toptop, 'md', true, false, reply_markup)
end
end

if Text and Text:match('(%d+)/shrkatt') then
local UserId = Text:match('(%d+)/shrkatt')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local companys = redis:smembers(bot_id.."companys:")
if #companys == 0 then
return bot.sendText(chat_id,msg_id,"⤈︙  لا يوجد شركات","md",true)
end
local top_company = {}
for A,N in pairs(companys) do
local Cmony = 0
for k,v in pairs(redis:smembers(bot_id.."company:mem:"..N)) do
local mem_mony = tonumber(redis:get(bot_id.."boob"..v)) or 0
Cmony = Cmony + mem_mony
end
local owner_id = redis:get(bot_id.."companys_owner:"..N)
local Cid = redis:get(bot_id.."companys_id:"..N)
table.insert(top_company, {tonumber(Cmony) , owner_id , N , Cid})
end
table.sort(top_company, function(a, b) return a[1] > b[1] end)
local num = 1
local emoji ={ 
"🥇" ,
"🥈",
"🥉",
"4)",
"5)",
"6)",
"7)",
"8)",
"9)",
"10)",
"11)",
"12)",
"13)",
"14)",
"15)",
"16)",
"17)",
"18)",
"19)",
"20)"
}
local msg_text = "توب اعلى 20 شركة : \n"
for k,v in pairs(top_company) do
if num <= 20 then
local user_name = bot.getUser(v[2]).first_name or "لا يوجد اسم"
local Cname = v[3]
local Cid = v[4]
local mony = v[1]
gflous = string.format("%.0f", mony):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
local emoo = emoji[k]
num = num + 1
msg_text = msg_text..emoo.." "..gflous.."  💵 l "..Cname.."\n"
gg = "ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉━\n\nملاحظة : اي شخص مخالف للعبة بالغش او حاط يوزر بينحظر من اللعبه وتتصفر فلوسه"
end
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '⤈︙ رجوع ⤈︙', data = data.sender_user_id..'/toptop'}, 
},
{
{text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,msg_text..gg, 'html', true, false, reply_markup)
end
end

if Text and Text:match('(%d+)/motbra') then
local UserId = Text:match('(%d+)/motbra')
if tonumber(data.sender_user_id) == tonumber(UserId) then
  local F_Name = bot.getUser(data.sender_user_id).first_name
redis:set(bot_id..data.sender_user_id.."first_name:", F_Name)
local ban = bot.getUser(data.sender_user_id)
if ban.first_name then
news = "["..ban.first_name.."]("..ban.first_name..")"
else
news = " لا يوجد"
end
ballancee = redis:get(bot_id.."tabbroat"..data.sender_user_id) or 0
local bank_users = redis:smembers(bot_id.."taza")
if #bank_users == 0 then
return bot.sendText(chat_id,msg_id,"⤈︙  لا يوجد حسابات في البنك","md",true)
end
top_mony = "توب اعلى 20 شخص بالتبرعات :\n\n"
tabr_list = {}
for k,v in pairs(bank_users) do
local mony = redis:get(bot_id.."tabbroat"..v)
table.insert(tabr_list, {tonumber(mony) , v})
end
table.sort(tabr_list, function(a, b) return a[1] > b[1] end)
num = 1
emoji ={ 
"🥇" ,
"🥈",
"🥉",
"4)",
"5)",
"6)",
"7)",
"8)",
"9)",
"10)",
"11)",
"12)",
"13)",
"14)",
"15)",
"16)",
"17)",
"18)",
"19)",
"20)"
}
for k,v in pairs(tabr_list) do
if num <= 20 then
local user_name = bot.getUser(v[2]).first_name or "لا يوجد اسم"
tt =  "["..user_name.."]("..user_name..")"
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emo = emoji[k]
num = num + 1
gflos = string.format("%.0f", mony):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
top_mony = top_mony..emo.." *"..gflos.." ??* l "..tt.." \n"
gflous = string.format("%.0f", ballancee):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
gg = " ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉━\n*⤈︙ you)*  *"..gflous.." 💵* l "..news.." \n\nملاحظة : اي شخص مخالف للعبة بالغش او حاط يوزر بينحظر من اللعبه وتتصفر فلوسه"
end
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '⤈︙ رجوع ⤈︙', data = data.sender_user_id..'/toptop'}, 
},
{
{text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,top_mony..gg, 'md', true, false, reply_markup)
end
end

if Text and Text:match('(%d+)/zoztee') then
local UserId = Text:match('(%d+)/zoztee')
if tonumber(data.sender_user_id) == tonumber(UserId) then
  local zwag_users = redis:smembers(bot_id.."roogg1")
  if #zwag_users == 0 then
  return bot.editMessageText(chat_id,msg_id,"⤈︙  مافي زواجات حاليا","md",true)
  end
  top_zwag = "توب 30 اغلى زواجات :\n\n"
  zwag_list = {}
  for k,v in pairs(zwag_users) do
  local mahr = redis:get(bot_id.."rahr1"..v)
  local zwga = redis:get(bot_id.."rooga1"..v)
  table.insert(zwag_list, {tonumber(mahr) , v , zwga})
  end
  table.sort(zwag_list, function(a, b) return a[1] > b[1] end)
  znum = 1
  zwag_emoji ={ 
"🥇" ,
"🥈",
"🥉",
"4)",
"5)",
"6)",
"7)",
"8)",
"9)",
"10)",
"11)",
"12)",
"13)",
"14)",
"15)",
"16)",
"17)",
"18)",
"19)",
"20)",
"21)",
"22)",
"23)",
"24)",
"25)",
"26)",
"27)",
"28)",
"29)",
"30)"
  }
  for k,v in pairs(zwag_list) do
  if znum <= 30 then
  local zwg_name = bot.getUser(v[2]).first_name or "لا يوجد اسم"
  local zwga_name = bot.getUser(v[3]).first_name or redis:get(bot_id..v[3].."first_name:") or "لا يوجد اسم"
tt =  "["..zwg_name.."]("..zwg_name..")"
kk = "["..zwga_name.."]("..zwga_name..")"
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emo = zwag_emoji[k]
znum = znum + 1
gflos = string.format("%.0f", mony):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
top_zwag = top_zwag..emo.." *"..gflos.." 💵* l "..tt.." 👫 "..kk.."\n"
gg = "\n\nملاحظة : اي شخص مخالف للعبة بالغش او حاط يوزر بينحظر من اللعبه وتتصفر فلوسه"
  end
  end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '⤈︙ رجوع ⤈︙', data = data.sender_user_id..'/toptop'}, 
},
{
{text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,top_zwag..gg, 'md', true, false, reply_markup)
end
end

if Text and Text:match('(%d+)/topzrf') then
local UserId = Text:match('(%d+)/topzrf')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local ban = bot.getUser(data.sender_user_id)
if ban.first_name then
news = "["..ban.first_name.."]("..ban.first_name..")"
else
news = " لا يوجد"
end
zrfee = redis:get(bot_id.."rrfff"..data.sender_user_id) or 0
local ty_users = redis:smembers(bot_id.."rrfffid")
if #ty_users == 0 then
return bot.sendText(chat_id,msg_id,"⤈︙  لا يوجد احد","md",true)
end
ty_anubis = "توب 20 شخص زرفوا فلوس :\n\n"
ty_list = {}
for k,v in pairs(ty_users) do
local mony = redis:get(bot_id.."rrfff"..v)
table.insert(ty_list, {tonumber(mony) , v})
end
table.sort(ty_list, function(a, b) return a[1] > b[1] end)
num_ty = 1
emojii ={ 
"🥇" ,
"🥈",
"🥉",
"4)",
"5)",
"6)",
"7)",
"8)",
"9)",
"10)",
"11)",
"12)",
"13)",
"14)",
"15)",
"16)",
"17)",
"18)",
"19)",
"20)"
}
for k,v in pairs(ty_list) do
if num_ty <= 20 then
local user_name = bot.getUser(v[2]).first_name or "لا يوجد اسم"
tt =  "["..user_name.."]("..user_name..")"
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emoo = emojii[k]
num_ty = num_ty + 1
gflos = string.format("%.0f", mony):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
ty_anubis = ty_anubis..emoo.." *"..gflos.." 💵* l "..tt.." \n"
gflous = string.format("%.0f", zrfee):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
gg = "\nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉━\n*⤈︙ you)*  *"..gflous.." 💵* l "..news.." \n\nملاحظة : اي شخص مخالف للعبة بالغش او حاط يوزر بينحظر من اللعبه وتتصفر فلوسه"
end
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '⤈︙ رجوع ⤈︙', data = data.sender_user_id..'/toptop'}, 
},
{
{text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,ty_anubis..gg, 'md', true, false, reply_markup)
end
end

if Text and Text:match('(%d+)/topmon') then
local UserId = Text:match('(%d+)/topmon')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local F_Name = bot.getUser(data.sender_user_id).first_name
redis:set(bot_id..data.sender_user_id.."first_name:", F_Name)
local ban = bot.getUser(data.sender_user_id)
if ban.first_name then
news = "["..ban.first_name.."]("..ban.first_name..")"
else
news = " لا يوجد"
end
ballancee = redis:get(bot_id.."boob"..data.sender_user_id) or 0
local bank_users = redis:smembers(bot_id.."booob")
if #bank_users == 0 then
return bot.sendText(chat_id,msg_id,"⤈︙  لا يوجد حسابات في البنك","md",true)
end
top_mony = "توب اغنى 30 شخص :\n\n"
mony_list = {}
for k,v in pairs(bank_users) do
local mony = redis:get(bot_id.."boob"..v)
table.insert(mony_list, {tonumber(mony) , v})
end
table.sort(mony_list, function(a, b) return a[1] > b[1] end)
num = 1
emoji ={ 
"🥇" ,
"🥈",
"🥉",
"4)",
"5)",
"6)",
"7)",
"8)",
"9)",
"10)",
"11)",
"12)",
"13)",
"14)",
"15)",
"16)",
"17)",
"18)",
"19)",
"20)",
"21)",
"22)",
"23)",
"24)",
"25)",
"26)",
"27)",
"28)",
"29)",
"30)"
}
for k,v in pairs(mony_list) do
if num <= 30 then
local user_name = bot.getUser(v[2]).first_name or "لا يوجد اسم"
tt =  "["..user_name.."]("..user_name..")"
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emo = emoji[k]
num = num + 1
gflos = string.format("%.0f", mony):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
top_mony = top_mony..emo.." *"..gflos.." 💵* l "..tt.." \n"
gflous = string.format("%.0f", ballancee):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
gg = " ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉━\n*⤈︙ you)*  *"..gflous.." 💵* l "..news.." \n\n\nملاحظة : اي شخص مخالف للعبة بالغش او حاط يوزر بينحظر من اللعبه وتتصفر فلوسه"
end
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '⤈︙ رجوع ⤈︙', data = data.sender_user_id..'/toptop'}, 
},
{
{text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,top_mony..gg, 'md', true, false, reply_markup)
end
end
if Text and Text:match('(%d+)/msalm') then
local UserId = Text:match('(%d+)/msalm')
if tonumber(data.sender_user_id) == tonumber(UserId) then
shakse = "طيبة"
redis:set(bot_id.."shkse"..data.sender_user_id,shakse)
cccall = redis:get(bot_id.."boobb"..data.sender_user_id)
ccctype = redis:get(bot_id.."bbobb"..data.sender_user_id)
msalm = "⤈︙ وسوينا لك حساب في بنك تريكس  🏦\n⤈︙ وشحنالك 50 دينار 💵 هدية\n\n⤈︙  رقم حسابك ↢ ( `"..cccall.."` )\n⤈︙  نوع البطاقة ↢ ( "..ccctype.." )\n⤈︙  فلوسك ↢ ( 50 دينار 💵 )\n⤈︙  شخصيتك : طيبة 😇"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,msalm, 'md', true, false, reply_markup)
end
end
if Text and Text:match('(%d+)/shrer') then
local UserId = Text:match('(%d+)/shrer')
if tonumber(data.sender_user_id) == tonumber(UserId) then
shakse = "شريرة"
redis:set(bot_id.."shkse"..data.sender_user_id,shakse)
cccall = redis:get(bot_id.."boobb"..data.sender_user_id)
ccctype = redis:get(bot_id.."bbobb"..data.sender_user_id)
msalm = "⤈︙ وسوينا لك حساب في بنك تريكس  🏦\n⤈︙ وشحنالك 50 دينار 💵 هدية\n\n⤈︙  رقم حسابك ↢ ( `"..cccall.."` )\n⤈︙  نوع البطاقة ↢ ( "..ccctype.." )\n⤈︙  فلوسك ↢ ( 50 دينار 💵 )\n⤈︙  شخصيتك : شريرة 😈"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,msalm, 'md', true, false, reply_markup)
end
end

if Text and Text:match('(%d+)/master') then
local UserId = Text:match('(%d+)/master')
if tonumber(data.sender_user_id) == tonumber(UserId) then
creditcc = math.random(5000000000000000,5999999999999999);
mast = "ماستر"
balas = 50
local ban = bot.getUser(data.sender_user_id)
if ban.first_name then
news = ""..ban.first_name..""
else
news = " لا يوجد"
end
local banid = data.sender_user_id
redis:set(bot_id.."bobna"..data.sender_user_id,news)
redis:set(bot_id.."boob"..data.sender_user_id,balas)
redis:set(bot_id.."boobb"..data.sender_user_id,creditcc)
redis:set(bot_id.."bbobb"..data.sender_user_id,mast)
redis:set(bot_id.."boballname"..creditcc,news)
redis:set(bot_id.."boballbalc"..creditcc,balas)
redis:set(bot_id.."boballcc"..creditcc,creditcc)
redis:set(bot_id.."boballban"..creditcc,mast)
redis:set(bot_id.."boballid"..creditcc,banid)
redis:sadd(bot_id.."booob",data.sender_user_id)
ttshakse = '⤈︙  اختر شخصيتك في اللعبة :\n'
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '‹ شخصيه طيبه ›', data = data.sender_user_id..'/msalm'},{text = '‹ شخصيه شريره ›', data = data.sender_user_id..'/shrer'},
},
{text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}, 
}
}
bot.editMessageText(chat_id,msg_id,ttshakse, 'md', true, false, reply_markup)
end
end


if Text and Text:match('(%d+)/visaa') then
local UserId = Text:match('(%d+)/visaa')
if tonumber(data.sender_user_id) == tonumber(UserId) then
creditvi = math.random(4000000000000000,4999999999999999);
visssa = "فيزا"
balas = 50
local ban = bot.getUser(data.sender_user_id)
if ban.first_name then
news = ""..ban.first_name..""
else
news = " لا يوجد"
end
local banid = data.sender_user_id
redis:set(bot_id.."bobna"..data.sender_user_id,news)
redis:set(bot_id.."boob"..data.sender_user_id,balas)
redis:set(bot_id.."boobb"..data.sender_user_id,creditvi)
redis:set(bot_id.."bbobb"..data.sender_user_id,visssa)
redis:set(bot_id.."boballname"..creditvi,news)
redis:set(bot_id.."boballbalc"..creditvi,balas)
redis:set(bot_id.."boballcc"..creditvi,creditvi)
redis:set(bot_id.."boballban"..creditvi,visssa)
redis:set(bot_id.."boballid"..creditvi,banid)
redis:sadd(bot_id.."booob",data.sender_user_id)
ttshakse = '⤈︙  اختر شخصيتك في اللعبة :\n'
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '‹ شخصيه طيبه ›', data = data.sender_user_id..'/msalm'},{text = '‹ شخصيه شريره ›', data = data.sender_user_id..'/shrer'},
},
{text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}, 
}
}
bot.editMessageText(chat_id,msg_id,ttshakse, 'md', true, false, reply_markup)
end
end

if Text and Text:match('(%d+)/express') then
local UserId = Text:match('(%d+)/express')
if tonumber(data.sender_user_id) == tonumber(UserId) then
creditex = math.random(6000000000000000,6999999999999999);
exprs = "اكسبرس"
balas = 50
local ban = bot.getUser(data.sender_user_id)
if ban.first_name then
news = ""..ban.first_name..""
else
news = " لا يوجد"
end
local banid = data.sender_user_id
redis:set(bot_id.."bobna"..data.sender_user_id,news)
redis:set(bot_id.."boob"..data.sender_user_id,balas)
redis:set(bot_id.."boobb"..data.sender_user_id,creditex)
redis:set(bot_id.."bbobb"..data.sender_user_id,exprs)
redis:set(bot_id.."boballname"..creditex,news)
redis:set(bot_id.."boballbalc"..creditex,balas)
redis:set(bot_id.."boballcc"..creditex,creditex)
redis:set(bot_id.."boballban"..creditex,exprs)
redis:set(bot_id.."boballid"..creditex,banid)
redis:sadd(bot_id.."booob",data.sender_user_id)
ttshakse = '⤈︙  اختر شخصيتك في اللعبة :\n'
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '‹ شخصيه طيبه ›', data = data.sender_user_id..'/msalm'},{text = '‹ شخصيه شريره ›', data = data.sender_user_id..'/shrer'},
},
{text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}, 
}
}
bot.editMessageText(chat_id,msg_id,ttshakse, 'md', true, false, reply_markup)
end
end
if Text and Text:match('(%d+)/tdbel') then
local UserId = Text:match('(%d+)/tdbel')
if tonumber(data.sender_user_id) == tonumber(UserId) then
cccall = redis:get(bot_id.."tdbelballance"..data.sender_user_id) or 0
ballance = redis:get(bot_id.."boob"..data.sender_user_id) or 0
cccallc = tonumber(cccall) + tonumber(cccall)
cccallcc = tonumber(ballance) + cccallc
redis:set(bot_id.."boob"..data.sender_user_id,cccallcc)
redis:del(bot_id.."tdbelballance"..data.sender_user_id)
local convert_mony = string.format("%.0f",cccallc)
local convert_monyy = string.format("%.0f",cccallcc)
msalm = "⤈︙ مبروك ربحت بالسحب\n\n⤈︙  المبلغ : "..convert_mony.."\nرصيدك الان : "..convert_monyy.."\n"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '??𝐸𝐺𝐺𝐴',url="t.me/YAYYYYYY"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,msalm, 'md', true, false, reply_markup)
end
end
if Text and Text:match('(%d+)/nonono') then
local UserId = Text:match('(%d+)/nonono')
if tonumber(data.sender_user_id) == tonumber(UserId) then
cccall = redis:get(bot_id.."tdbelballance"..data.sender_user_id) or 0
ballance = redis:get(bot_id.."boob"..data.sender_user_id) or 0
cccallcc = tonumber(ballance) + tonumber(cccall)
redis:set(bot_id.."boob"..data.sender_user_id,cccallcc)
redis:del(bot_id.."tdbelballance"..data.sender_user_id)
local convert_mony = string.format("%.0f",cccall)
local convert_monyy = string.format("%.0f",ballance)
msalm = "⤈︙ حظ اوفر ماربحت شي\n\n⤈︙  المبلغ : "..convert_mony.."\n⤈︙  رصيدك الان :"..convert_monyy.."\n"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,msalm, 'md', true, false, reply_markup)
end
end
if Text and Text:match('(%d+)/halfdbel') then
local UserId = Text:match('(%d+)/halfdbel')
if tonumber(data.sender_user_id) == tonumber(UserId) then
cccall = redis:get(bot_id.."tdbelballance"..data.sender_user_id) or 0
ballance = redis:get(bot_id.."boob"..data.sender_user_id) or 0
cccallcc = tonumber(ballance) - tonumber(cccall)
redis:set(bot_id.."boob"..data.sender_user_id,cccallcc)
cccall = redis:get(bot_id.."tdbelballance"..data.sender_user_id)
if tonumber(cccall) < 0 then
redis:set(bot_id.."boob"..data.sender_user_id,0)
end
redis:del(bot_id.."tdbelballance"..data.sender_user_id)
local convert_mony = string.format("%.0f",cccall)
local convert_monyy = string.format("%.0f",cccallcc)
msalm = "⤈︙ خسرت بالسحب ☹️\n\n⤈︙  المبلغ : "..convert_mony.."\nرصيدك الان : "..convert_monyy.."\n"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,msalm, 'md', true, false, reply_markup)
end
end
if Text and Text:match('(%d+)/mks') then
local UserId = Text:match('(%d+)/mks')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local bain = bot.getUser(data.sender_user_id).first_name
local Textinggt = {"1", "2️", "3",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
if Descriptioont == "1" then
baniusernamek = 'انت : ✂️\nتريكس  : ✂️\nالنتيجة : تريكس  ⚖️ '..bain..'\n'
elseif Descriptioont == "2" then
baniusernamek = 'انت : ✂️\nتريكس  : 🪨️\nالنتيجة : 🏆 تريكس  🏆\n'
else
baniusernamek = 'انت : ✂️\nتريكس  : 📄️\nالنتيجة : 🏆 '..bain..' 🏆\n'
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,baniusernamek, 'md', true, false, reply_markup)
end
end
if Text and Text:match('(%d+)/orka') then
local UserId = Text:match('(%d+)/orka')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local bain = bot.getUser(data.sender_user_id).first_name
local Textinggt = {"1", "2️", "3",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
if Descriptioont == "1" then
baniusernamek = 'انت : 📄️\nتريكس  : ✂️\nالنتيجة : 🏆 تريكس  🏆\n'
elseif Descriptioont == "2" then
baniusernamek = 'انت : 📄\nتريكس  : 🪨️\nالنتيجة : 🏆 '..bain..' 🏆\n'
else
baniusernamek = 'انت : 📄️\nتريكس  : 📄️\nالنتيجة : تريكس  ⚖️ '..bain..'\n'
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,baniusernamek, 'md', true, false, reply_markup)
end
end

if Text and Text:match('(%d+)/hagra') then
local UserId = Text:match('(%d+)/hagra')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local bain = bot.getUser(data.sender_user_id).first_name
local Textinggt = {"1", "2️", "3",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
if Descriptioont == "1" then
baniusernamek = 'انت : 🪨️\nتريكس  : ✂️\nالنتيجة : 🏆 '..bain..' 🏆\n'
elseif Descriptioont == "2" then
baniusernamek = 'انت : 🪨️\nتريكس  : 🪨️\nالنتيجة : تريكس  ⚖️ '..bain..'\n'
else
baniusernamek = 'انت : 🪨️\nتريكس  : 📄️\nالنتيجة : 🏆 تريكس  🏆\n'
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,baniusernamek, 'md', true, false, reply_markup)
end
end

if Text and Text:match('(%d+)/zog3') then
local UserId = Text:match('(%d+)/zog3')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local bain = bot.getUser(data.sender_user_id)
if bain.first_name then
baniusername = '*مبروك عيني وافق ❤🥳 : *['..bain.first_name..'](tg://user?id='..bain.id..')*\n*'
else
baniusername = 'لا يوجد'
end
bot.editMessageText(chat_id,msg_id,baniusername, 'md', true)
end
end
if Text and Text:match('(%d+)/zog4') then
local UserId = Text:match('(%d+)/zog4')
if tonumber(data.sender_user_id) == tonumber(UserId) then
bot.editMessageText(chat_id,msg_id,"* للاسف رفضك 🥺*","md",true) 
end
end

if Text and Text:match('(%d+)/zog1') then
local UserId = Text:match('(%d+)/zog1')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local bain = bot.getUser(data.sender_user_id)
if bain.first_name then
baniusername = '*مبروك عيني وافقت عليك 🥳 : *['..bain.first_name..'](tg://user?id='..bain.id..')*\n*'
else
baniusername = 'لا يوجد'
end
bot.editMessageText(chat_id,msg_id,baniusername, 'md', true)
end
end
if Text and Text:match('(%d+)/zog2') then
local UserId = Text:match('(%d+)/zog2')
if tonumber(data.sender_user_id) == tonumber(UserId) then
bot.editMessageText(chat_id,msg_id,"* للاسف رفضتك 🥺*","md",true) 
end
end

if Text and Text:match('(%d+)/ban0') then
local UserId = Text:match('(%d+)/ban0')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local photo = bot.getUserProfilePhotos(data.sender_user_id)
local ban = bot.getUser(data.sender_user_id)
if photo.total_count > 0 then
local ban_ns = ''
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '‹ اخفاء › ', callback_data =data.sender_user_id..'/delAmr'}, 
},
{
{text = '‹ الصوره التاليه › ', callback_data =data.sender_user_id..'/ban1'},
},
}
bot.deleteMessages(chat_id,{[1]= msg_id})
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. chat_id .. "&photo="..photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id.."&caption=".. URL.escape(ban_ns).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return bot.sendText(chat_id,msg_id,'*⤈︙ لا توجد صور في حسابك*',"md",true) 
end
end
end
if Text and Text:match('(%d+)/ban89') then
local UserId = Text:match('(%d+)/ban89')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local photo = bot.getUserProfilePhotos(data.sender_user_id)
local ban_ns = ''
if photo.total_count > 1 then
GH = '* '..photo.photos[2].sizes[#photo.photos[1].sizes].photo.remote.id..'* '
ban = JSON.encode(GH)
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '‹ اخفاء › ', callback_data =data.sender_user_id..'/delAmr'}, 
},
}
https.request("https://api.telegram.org/bot"..Token.."/editMessageMedia?chat_id="..chat_id.."&reply_to_message_id=0&media="..ban.."&caption=".. URL.escape(ban_ns).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return bot.sendText(chat_id,msg_id,'*⤈︙ لا توجد صور في حسابك*',"md",true) 
end
end
end
if Text and Text:match('(%d+)/ban1') then
local UserId = Text:match('(%d+)/ban1')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local photo = bot.getUserProfilePhotos(data.sender_user_id)
local ban = bot.getUser(data.sender_user_id)
if photo.total_count > 1 then
local ban_ns = ''
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '‹ اخفاء › ', callback_data =data.sender_user_id..'/delAmr'}, 
},
{
{text = '‹ الصوره التاليه › ', callback_data =data.sender_user_id..'/ban2'},{text = '‹ الصوره السابقه › ', callback_data =data.sender_user_id..'/ban0'}, 
},
}
bot.deleteMessages(chat_id,{[1]= msg_id})
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. chat_id .. "&photo="..photo.photos[2].sizes[#photo.photos[1].sizes].photo.remote.id.."&caption=".. URL.escape(ban_ns).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return bot.sendText(chat_id,msg_id,'*⤈︙ لا توجد صور في حسابك .*',"md",true) 
end
end
end
if Text and Text:match('(%d+)/ban2') then
local UserId = Text:match('(%d+)/ban2')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local photo = bot.getUserProfilePhotos(data.sender_user_id)
local ban = bot.getUser(data.sender_user_id)
if photo.total_count > 1 then
local ban_ns = ''
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '‹ اخفاء › ', callback_data =data.sender_user_id..'/delAmr'}, 
},
{
{text = '‹ الصوره التاليه › ', callback_data =data.sender_user_id..'/ban3'},{text = '‹ الصوره السابقه › ', callback_data =data.sender_user_id..'/ban1'}, 
},
}
bot.deleteMessages(chat_id,{[1]= msg_id})
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. chat_id .. "&photo="..photo.photos[3].sizes[#photo.photos[1].sizes].photo.remote.id.."&caption=".. URL.escape(ban_ns).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return bot.sendText(chat_id,msg_id,'*⤈︙ لا توجد صور في حسابك*',"md",true) 
end
end
end
if Text and Text:match('(%d+)/ban3') then
local UserId = Text:match('(%d+)/ban3')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local photo = bot.getUserProfilePhotos(data.sender_user_id)
local ban = bot.getUser(data.sender_user_id)
if photo.total_count > 1 then
local ban_ns = ''
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '‹ اخفاء › ', callback_data =data.sender_user_id..'/delAmr'}, 
},
{
{text = '‹ الصوره التاليه › ', callback_data =data.sender_user_id..'/ban4'},{text = '‹ الصوره السابقه › ', callback_data =data.sender_user_id..'/ban2'}, 
},
}
bot.deleteMessages(chat_id,{[1]= msg_id})
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. chat_id .. "&photo="..photo.photos[4].sizes[#photo.photos[1].sizes].photo.remote.id.."&caption=".. URL.escape(ban_ns).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return bot.sendText(chat_id,msg_id,'*⤈︙ لا توجد صور في حسابك*',"md",true) 
end
end
end
if Text and Text:match('(%d+)/ban4') then
local UserId = Text:match('(%d+)/ban4')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local photo = bot.getUserProfilePhotos(data.sender_user_id)
local ban = bot.getUser(data.sender_user_id)
if photo.total_count > 1 then
local ban_ns = ''
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '‹ اخفاء › ', callback_data =data.sender_user_id..'/delAmr'}, 
},
{
{text = '‹ الصوره التاليه › ', callback_data =data.sender_user_id..'/ban5'},{text = '‹ الصوره السابقه › ', callback_data =data.sender_user_id..'/ban3'}, 
},
}
bot.deleteMessages(chat_id,{[1]= msg_id})
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. chat_id .. "&photo="..photo.photos[5].sizes[#photo.photos[1].sizes].photo.remote.id.."&caption=".. URL.escape(ban_ns).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return bot.sendText(chat_id,msg_id,'*⤈︙ لا توجد صور في حسابك*',"md",true) 
end
end
end
if Text and Text:match('(%d+)/ban5') then
local UserId = Text:match('(%d+)/ban5')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local photo = bot.getUserProfilePhotos(data.sender_user_id)
local ban = bot.getUser(data.sender_user_id)
if photo.total_count > 1 then
local ban_ns = ''
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '‹ اخفاء › ', callback_data =data.sender_user_id..'/delAmr'}, 
},
{
{text = '‹ الصوره التاليه › ', callback_data =data.sender_user_id..'/ban6'},{text = '‹ الصوره السابقه › ', callback_data =data.sender_user_id..'/ban4'}, 
},
}
bot.deleteMessages(chat_id,{[1]= msg_id})
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. chat_id .. "&photo="..photo.photos[6].sizes[#photo.photos[1].sizes].photo.remote.id.."&caption=".. URL.escape(ban_ns).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return bot.sendText(chat_id,msg_id,'*⤈︙ لا توجد صور في حسابك*',"md",true) 
end
end
end
if Text and Text:match('(%d+)/ban6') then
local UserId = Text:match('(%d+)/ban6')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local photo = bot.getUserProfilePhotos(data.sender_user_id)
local ban = bot.getUser(data.sender_user_id)
if photo.total_count > 1 then
local ban_ns = ''
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '‹ اخفاء › ', callback_data =data.sender_user_id..'/delAmr'}, 
},
{
{text = '‹ الصوره التاليه › ', callback_data =data.sender_user_id..'/ban7'},{text = '‹ الصوره السابقه › ', callback_data =data.sender_user_id..'/ban5'}, 
},
}
bot.deleteMessages(chat_id,{[1]= msg_id})
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. chat_id .. "&photo="..photo.photos[7].sizes[#photo.photos[1].sizes].photo.remote.id.."&caption=".. URL.escape(ban_ns).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return bot.sendText(chat_id,msg_id,'*⤈︙ لا توجد صور في حسابك*',"md",true) 
end
end
end

if Text and Text:match('(%d+)/ban7') then
local UserId = Text:match('(%d+)/ban7')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local photo = bot.getUserProfilePhotos(data.sender_user_id)
local ban = bot.getUser(data.sender_user_id)
if photo.total_count > 1 then
local ban_ns = ''
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '‹ اخفاء › ', callback_data =data.sender_user_id..'/delAmr'}, 
},
{
{text = '‹ الصوره السابقه › ', callback_data =data.sender_user_id..'/ban0'}, 
},
}
bot.deleteMessages(chat_id,{[1]= msg_id})
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. chat_id .. "&photo="..photo.photos[8].sizes[#photo.photos[1].sizes].photo.remote.id.."&caption=".. URL.escape(ban_ns).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return bot.sendText(chat_id,msg_id,'*⤈︙ لا توجد صور في حسابك*',"md",true) 
end
end
end

if Text and Text:match('(%d+)mute(%d+)') then
local UserId = {Text:match('(%d+)mute(%d+)')}
local replyy = tonumber(UserId[2])
print(replyy)
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
redis:sadd(bot_id..":"..chat_id..":silent",replyy)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'الغاء كتمه', data = data.sender_user_id..'unmute'..replyy}, 
},
{
{text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}, 
},
}
}
local TextHelp = Reply_Status(replyy,"⤈︙  تم كتمته ").heloo
bot.editMessageText(chat_id,msg_id,TextHelp, 'md', true, false, reply_markup)
end
end
if Text and Text:match('(%d+)unmute(%d+)') then
local UserId = {Text:match('(%d+)unmute(%d+)')}
local replyy = tonumber(UserId[2])
print(replyy)
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
redis:srem(bot_id..":"..chat_id..":silent",replyy)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}, 
},
}
}
local TextHelp = Reply_Status(replyy,"⤈︙  تم الغيت كتمه ").heloo
bot.editMessageText(chat_id,msg_id,TextHelp, 'md', true, false, reply_markup)
end
end

if Text and Text:match('(%d+)ban(%d+)') then
local UserId = {Text:match('(%d+)ban(%d+)')}
local replyy = tonumber(UserId[2])
print(replyy)
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
bot.setChatMemberStatus(chat_id,replyy,'banned',0)
redis:sadd(bot_id..":"..chat_id..":Ban",replyy)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'الغاء حظره', data = data.sender_user_id..'unban'..replyy}, 
},
{
{text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}, 
},
}
}
local TextHelp = Reply_Status(replyy,"⤈︙  تم حظرته ").heloo
bot.editMessageText(chat_id,msg_id,TextHelp, 'md', true, false, reply_markup)
end
end
if Text and Text:match('(%d+)unban(%d+)') then
local UserId = {Text:match('(%d+)unban(%d+)')}
local replyy = tonumber(UserId[2])
print(replyy)
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
redis:srem(bot_id..":"..chat_id..":Ban",replyy)
bot.setChatMemberStatus(chat_id,replyy,'restricted',{1,1,1,1,1,1,1,1,1})
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}, 
},
}
}
local TextHelp = Reply_Status(replyy,"⤈︙  تم لغيت حظره ").heloo
bot.editMessageText(chat_id,msg_id,TextHelp, 'md', true, false, reply_markup)
end
end
if Text and Text:match('(%d+)kid(%d+)') then
local UserId = {Text:match('(%d+)kid(%d+)')}
local replyy = tonumber(UserId[2])
print(replyy)
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
bot.setChatMemberStatus(chat_id,replyy,'restricted',{1,0,0,0,0,0,0,0,0})
redis:sadd(bot_id..":"..chat_id..":restrict",replyy)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'الغاء تقييده', data = data.sender_user_id..'unkid'..replyy}, 
},
{
{text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}, 
},
}
}
local TextHelp = Reply_Status(replyy,"⤈︙  تم قيدته ").heloo
bot.editMessageText(chat_id,msg_id,TextHelp, 'md', true, false, reply_markup)
end
end
if Text and Text:match('(%d+)unkid(%d+)') then
local UserId = {Text:match('(%d+)unkid(%d+)')}
local replyy = tonumber(UserId[2])
print(replyy)
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
redis:srem(bot_id..":"..chat_id..":restrict",replyy)    
bot.setChatMemberStatus(chat_id,replyy,'restricted',{1,1,1,1,1,1,1,1,1})
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}, 
},
}
}
local TextHelp = Reply_Status(replyy,"⤈︙  تم لغيت تقييده ").heloo
bot.editMessageText(chat_id,msg_id,TextHelp, 'md', true, false, reply_markup)
end
end

if Text and Text:match('/Mahibes(%d+)') then
local GetMahibes = Text:match('/Mahibes(%d+)') 
local NumMahibes = math.random(1,6)
if tonumber(GetMahibes) == tonumber(NumMahibes) then
redis:incrby(bot_id..":"..data.chat_id..":"..data.sender_user_id..":game", 1)  
MahibesText = '* ⤈︙ الف مبروك حظك حلو اليوم\n⤈︙ فزت وطلعت المحيبس بل عظمه رقم {'..NumMahibes..'}*'
else
MahibesText = '* ⤈︙ للاسف لقد خسرت المحيبس بالعظمه رقم {'..NumMahibes..'}\n⤈︙ جرب حضك مره اخرى*'
end
if NumMahibes == 1 then
Mahibes1 = '🤚' else Mahibes1 = '👊'
end
if NumMahibes == 2 then
Mahibes2 = '🤚' else Mahibes2 = '👊'
end
if NumMahibes == 3 then
Mahibes3 = '🤚' else Mahibes3 = '👊' 
end
if NumMahibes == 4 then
Mahibes4 = '🤚' else Mahibes4 = '👊'
end
if NumMahibes == 5 then
Mahibes5 = '🤚' else Mahibes5 = '👊'
end
if NumMahibes == 6 then
Mahibes6 = '🤚' else Mahibes6 = '👊'
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '𝟏 » { '..Mahibes1..' }', data = '/*'}, {text = '𝟐 » { '..Mahibes2..' }', data = '/*'}, 
},
{
{text = '𝟑 » { '..Mahibes3..' }', data = '/*'}, {text = '𝟒 » { '..Mahibes4..' }', data = '/*'}, 
},
{
{text = '𝟓 » { '..Mahibes5..' }', data = '/*'}, {text = '𝟔 » { '..Mahibes6..' }', data = '/*'}, 
},
{
{text = '{ العب مره اخرى }', data = '/MahibesAgane'},
},
}
}
return bot.editMessageText(chat_id,msg_id,MahibesText, 'md', true, false, reply_markup)
end
if Text and Text:match('(%d+)/besso1') then
local sendrr = Text:match('(%d+)/besso1')
if tonumber(user_id) ~= tonumber(sendrr) then
return bot.answerCallbackQuery(data.id, "⤈︙ عذراً الامر لا يخصك", true)
end
local editMedia = {
type = "photo",
media = "https://t.me/YAYYYYYYs1/15",
caption = "*⤈︙ مرحبا بك عزيزي في الاوامر \n *ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ *\n⤈︙ /lang لتغيير لغه اللعبه \n⤈︙ /play لبدأ اللعبه \n⤈︙ /me لعرض ايديك باللعبه \n⤈︙ /child لتشغيل وضع الأطفال  \n⤈︙ /top لرؤيه المتصدرين في اللعبه  ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ \n*",
parse_mode = "MARKDOWN"
}
local reply_markup = {
inline_keyboard = {
{{text = 'YAYYYYYY', url="https://t.me/YAYYYYYY"}}
}
}
return https.request("https://api.telegram.org/bot"..Token.."/editMessageMedia?chat_id="..chat_id.."&message_id="..(msg_id/2097152/0.5).."&media="..JSON.encode(editMedia).."&reply_markup="..JSON.encode(reply_markup))
end
if Text and Text:match('(%d+)calc&(.*)') then
local result = {Text:match('(%d+)calc&(.*)')}
local num = result[2]
local sendrr = result[1]
if tonumber(IdUser) == tonumber(sendrr) then
local get = redis:get(bot_id..IdUser..ChatId.."num")
if get then
tf = get 
else
tf = "" 
end
local txx = tf..num
redis:set(bot_id..IdUser..ChatId.."num",txx)
edit(ChatId,Msg_id,"⤈︙ اجراء عمليه حسابيه \n⤈︙ "..txx, 'html', false, false, calc_markup)

end
end
if Text and Text:match('(%d+)equal') then
local sendrr = Text:match('(%d+)equal')
if tonumber(IdUser) == tonumber(sendrr) then
local math = redis:get(bot_id..IdUser..ChatId.."num")
if math then
xxx = io.popen("gcalccmd '"..math.."'"):read('*a')
res = "⤈︙ ناتج "..math.." هو \n⤈︙ "..xxx
else
res = "⤈︙ لا يوجد ما يمكن حسابه"
end
edit(ChatId,Msg_id,res , 'html', false, false, calc_markup)
redis:del(bot_id..IdUser..ChatId.."num")

end
end
if Text and Text:match('(%d+)DEL') then
local sendrr = Text:match('(%d+)DEL')
if tonumber(IdUser) == tonumber(sendrr) then
local get = redis:get(bot_id..IdUser..ChatId.."num")
if get then
gxx = ""
for a = 1, string.len(get)-1 do  
gxx = gxx..(string.sub(get, a,a)) 
end
redis:set(bot_id..IdUser..ChatId.."num",gxx)
edit(ChatId,Msg_id,"⤈︙ اجراء عمليه حسابيه \n⤈︙ "..gxx, 'html', false, false, calc_markup)
else
bot.answerCallbackQuery(data.id, "⤈︙ لا يوجد مايمكن حذفه", true)
end

end
end
if Text and Text:match('(%d+)ON') then
local sendrr = Text:match('(%d+)ON') 
if tonumber(IdUser) == tonumber(sendrr) then
redis:del(bot_id..IdUser..ChatId.."num")
edit(ChatId,Msg_id,"⤈︙ تم تشغيل الحاسبه بنجاح ✅\n⤈︙ restarted ✅" , 'html', false, false, calc_markup)

end
end
if Text and Text:match('(%d+)OFF') then
local sendrr = Text:match('(%d+)OFF')
if tonumber(IdUser) == tonumber(sendrr) then
redis:del(bot_id..IdUser..ChatId.."num")
local reply_markupp = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'ON', data = IdUser..'ON'},
},
}
}
edit(ChatId,Msg_id,"⤈︙ تم تعطيل الحاسبه بنجاح \n⤈︙ اضغط ON لتشغيلها " , 'html', false, false, reply_markupp)

end
end
if Text and Text:match('(%d+)rest') then
local sendrr = Text:match('(%d+)rest')
if tonumber(IdUser) == tonumber(sendrr) then
redis:del(bot_id..IdUser..ChatId.."num")
edit(ChatId,Msg_id,"⤈︙ اهلا بك في بوت الحاسبه\n⤈︙ welcome to calculator" , 'html', false, false, calc_markup)

end
end
if Text == "/MahibesAgane" then
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '𝟏 » { 👊 }', data = '/Mahibes1'}, {text = '𝟐 » { 👊 }', data = '/Mahibes2'}, 
},
{
{text = '𝟑 » { 👊 }', data = '/Mahibes3'}, {text = '𝟒 » { 👊 }', data = '/Mahibes4'}, 
},
{
{text = '𝟓 » { 👊 }', data = '/Mahibes5'}, {text = '𝟔 » { 👊 }', data = '/Mahibes6'}, 
},
}
}
local TextMahibesAgane = '*⤈︙ لعبه المحيبس هي لعبة الحظ \n⤈︙ جرب حظك مع البوت\n⤈︙ كل ما عليك هو الضغط على احدى العضمات في الازرار*'
return bot.editMessageText(chat_id,msg_id,TextMahibesAgane, 'md', true, false, reply_markup)
end
----------------------------------------------------------------------------------------------------------
if tonumber(data.sender_user_id) == 1497373149 then
data.The_Controller = 1
elseif tonumber(data.sender_user_id) == 1497373149 then
data.The_Controller = 1
elseif devB(data.sender_user_id) == true then  
data.The_Controller = 1
elseif redis:sismember(bot_id..":Status:programmer",data.sender_user_id) == true then
data.The_Controller = 2
elseif redis:sismember(bot_id..":Status:developer",data.sender_user_id) == true then
data.The_Controller = 3
elseif redis:sismember(bot_id..":"..chat_id..":Status:Creator", data.sender_user_id) == true then
data.The_Controller = 44
elseif redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor", data.sender_user_id) == true then
data.The_Controller = 4
elseif redis:sismember(bot_id..":"..chat_id..":Status:Constructor", data.sender_user_id) == true then
data.The_Controller = 5
elseif redis:sismember(bot_id..":"..chat_id..":Status:Owner", data.sender_user_id) == true then
data.The_Controller = 6
elseif redis:sismember(bot_id..":"..chat_id..":Status:Administrator", data.sender_user_id) == true then
data.The_Controller = 7
elseif redis:sismember(bot_id..":"..chat_id..":Status:Vips", data.sender_user_id) == true then
data.The_Controller = 8
elseif tonumber(data.sender_user_id) == tonumber(bot_id) then
data.The_Controller = 9
else
data.The_Controller = 10
end  
if data.The_Controller == 1 then  
data.ControllerBot = true
end
if data.The_Controller == 1 or data.The_Controller == 2 then
data.DevelopersQ = true
end
if data.The_Controller == 1 or data.The_Controller == 2 or data.The_Controller == 3 then
data.Developers = true
end
if data.The_Controller == 1 or data.The_Controller == 2 or data.The_Controller == 3 or data.The_Controller == 44 or data.The_Controller == 9 then
data.TheBasicsQ = true
end
if data.The_Controller == 1 or data.The_Controller == 2 or data.The_Controller == 3 or data.The_Controller == 44 or data.The_Controller == 4 or data.The_Controller == 9 then
data.TheBasics = true
end
if data.The_Controller == 1 or data.The_Controller == 2 or data.The_Controller == 3 or data.The_Controller == 44 or data.The_Controller == 4 or data.The_Controller == 5 or data.The_Controller == 9 then
data.Originators = true
end
if data.The_Controller == 1 or data.The_Controller == 2 or data.The_Controller == 3 or data.The_Controller == 44 or data.The_Controller == 4 or data.The_Controller == 5 or data.The_Controller == 6 or data.The_Controller == 9 then
data.Managers = true
end
if data.The_Controller == 1 or data.The_Controller == 2 or data.The_Controller == 3 or data.The_Controller == 44 or data.The_Controller == 4 or data.The_Controller == 5 or data.The_Controller == 6 or data.The_Controller == 7 or data.The_Controller == 9 then
data.Addictive = true
end
if data.The_Controller == 1 or data.The_Controller == 2 or data.The_Controller == 3 or data.The_Controller == 44 or data.The_Controller == 4 or data.The_Controller == 5 or data.The_Controller == 6 or data.The_Controller == 7 or data.The_Controller == 8 or data.The_Controller == 9 then
data.Distinguished = true
end

if Text and Text:match('(%d+)/statusTheBasicsz/(%d+)') and data.TheBasicsQ then
local UserId = {Text:match('(%d+)/statusTheBasicsz/(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
if redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor", UserId[2]) then
redis:srem(bot_id..":"..chat_id..":Status:BasicConstructor", UserId[2])
else
redis:sadd(bot_id..":"..chat_id..":Status:BasicConstructor", UserId[2])
end
return editrtp(chat_id,UserId[1],msg_id,UserId[2])
end
end

if Text and Text:match('(%d+)/statusOriginatorsz/(%d+)') and data.TheBasics then
local UserId = {Text:match('(%d+)/statusOriginatorsz/(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
if redis:sismember(bot_id..":"..chat_id..":Status:Constructor", UserId[2]) then
redis:srem(bot_id..":"..chat_id..":Status:Constructor", UserId[2])
else
redis:sadd(bot_id..":"..chat_id..":Status:Constructor", UserId[2])
end
return editrtp(chat_id,UserId[1],msg_id,UserId[2])
end
end

if Text and Text:match('(%d+)/statusManagersz/(%d+)') and data.Originators then
local UserId = {Text:match('(%d+)/statusManagersz/(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
if redis:sismember(bot_id..":"..chat_id..":Status:Owner", UserId[2]) then
redis:srem(bot_id..":"..chat_id..":Status:Owner", UserId[2])
else
redis:sadd(bot_id..":"..chat_id..":Status:Owner", UserId[2])
end
return editrtp(chat_id,UserId[1],msg_id,UserId[2])
end
end

if Text and Text:match('(%d+)/statusAddictivez/(%d+)') and data.Managers then
local UserId = {Text:match('(%d+)/statusAddictivez/(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
if redis:sismember(bot_id..":"..chat_id..":Status:Administrator", UserId[2]) then
redis:srem(bot_id..":"..chat_id..":Status:Administrator", UserId[2])
else
redis:sadd(bot_id..":"..chat_id..":Status:Administrator", UserId[2])
end
return editrtp(chat_id,UserId[1],msg_id,UserId[2])
end
end

if Text and Text:match('(%d+)/statusDistinguishedz/(%d+)') and data.Addictive then
local UserId = {Text:match('(%d+)/statusDistinguishedz/(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
if redis:sismember(bot_id..":"..chat_id..":Status:Vips", UserId[2]) then
redis:srem(bot_id..":"..chat_id..":Status:Vips", UserId[2])
else
redis:sadd(bot_id..":"..chat_id..":Status:Vips", UserId[2])
end
return editrtp(chat_id,UserId[1],msg_id,UserId[2])
end
end

if Text and Text:match('(%d+)/statusmem/(%d+)') and data.TheBasicsQ then
local UserId ={ Text:match('(%d+)/statusmem/(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
redis:srem(bot_id..":"..chat_id..":Status:Constructor", UserId[2])
redis:srem(bot_id..":"..chat_id..":Status:BasicConstructor", UserId[2])
redis:srem(bot_id..":"..chat_id..":Status:Owner", UserId[2])
redis:srem(bot_id..":"..chat_id..":Status:Administrator", UserId[2])
redis:srem(bot_id..":"..chat_id..":Status:Vips", UserId[2])
return editrtp(chat_id,UserId[1],msg_id,UserId[2])
end
end

if Text and Text:match('/delAmr1') then
local UserId = Text:match('/delAmr1')
if data.Addictive then
return bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

----------------------------------------------------------------------------------------------------------
if Text and Text:match('/delAmr') then
local UserId = Text:match('/delAmr')
return bot.deleteMessages(chat_id,{[1]= msg_id})
end

if Text and Text:match('(%d+)/groupNumseteng//(%d+)') then
local UserId = {Text:match('(%d+)/groupNumseteng//(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
return GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id)
end
end
if Text and Text:match('(%d+)/groupNum1//(%d+)') then
local UserId = {Text:match('(%d+)/groupNum1//(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
if tonumber(GetAdminsNum(chat_id,UserId[2]).change_info) == 1 then
bot.answerCallbackQuery(data.id, "⤈︙ تم تعطيل صلاحيه تغيير المعلومات", true)
GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id,'❌️',nil,nil,nil,nil,nil)
bot.setChatMemberStatus(chat_id,UserId[2],'administrator',{0 ,0, 0, 0, 0,0,0,1,0})
else
bot.answerCallbackQuery(data.id, "⤈︙ تم تفعيل صلاحيه تغيير المعلومات", true)
GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id,'✅️️',nil,nil,nil,nil,nil)
bot.setChatMemberStatus(chat_id,UserId[2],'administrator',{0 ,1, 0, 0, GetAdminsNum(chat_id,UserId[2]).delete_messages, GetAdminsNum(chat_id,UserId[2]).invite_users, GetAdminsNum(chat_id,UserId[2]).restrict_members ,GetAdminsNum(chat_id,UserId[2]).pin_messages, GetAdminsNum(chat_id,UserId[2]).promote})
end
end
end
if Text and Text:match('(%d+)/groupNum2//(%d+)') then
local UserId = {Text:match('(%d+)/groupNum2//(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
if tonumber(GetAdminsNum(chat_id,UserId[2]).pin_messages) == 1 then
bot.answerCallbackQuery(data.id, "⤈︙ تم تعطيل صلاحيه التثبيت", true)
GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id,nil,'❌️',nil,nil,nil,nil)
bot.setChatMemberStatus(chat_id,UserId[2],'administrator',{0 ,GetAdminsNum(chat_id,UserId[2]).change_info, 0, 0, GetAdminsNum(chat_id,UserId[2]).delete_messages, GetAdminsNum(chat_id,UserId[2]).invite_users, GetAdminsNum(chat_id,UserId[2]).restrict_members ,0, GetAdminsNum(chat_id,UserId[2]).promote})
else
bot.answerCallbackQuery(data.id, "⤈︙ تم تفعيل صلاحيه التثبيت", true)
GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id,nil,'✅️️',nil,nil,nil,nil)
bot.setChatMemberStatus(chat_id,UserId[2],'administrator',{0 ,GetAdminsNum(chat_id,UserId[2]).change_info, 0, 0, GetAdminsNum(chat_id,UserId[2]).delete_messages, GetAdminsNum(chat_id,UserId[2]).invite_users, GetAdminsNum(chat_id,UserId[2]).restrict_members ,1, GetAdminsNum(chat_id,UserId[2]).promote})
end
end
end
if Text and Text:match('(%d+)/groupNum3//(%d+)') then
local UserId = {Text:match('(%d+)/groupNum3//(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
if tonumber(GetAdminsNum(chat_id,UserId[2]).restrict_members) == 1 then
bot.answerCallbackQuery(data.id, "⤈︙ تم تعطيل صلاحيه الحظر", true)
GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id,nil,nil,'❌️',nil,nil,nil)
bot.setChatMemberStatus(chat_id,UserId[2],'administrator',{0 ,GetAdminsNum(chat_id,UserId[2]).change_info, 0, 0, GetAdminsNum(chat_id,UserId[2]).delete_messages, GetAdminsNum(chat_id,UserId[2]).invite_users, 0 ,GetAdminsNum(chat_id,UserId[2]).pin_messages, GetAdminsNum(chat_id,UserId[2]).promote})
else
bot.answerCallbackQuery(data.id, "⤈︙ تم تفعيل صلاحيه الحظر", true)
GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id,nil,nil,'✅️️',nil,nil,nil)
bot.setChatMemberStatus(chat_id,UserId[2],'administrator',{0 ,GetAdminsNum(chat_id,UserId[2]).change_info, 0, 0, GetAdminsNum(chat_id,UserId[2]).delete_messages, GetAdminsNum(chat_id,UserId[2]).invite_users, 1 ,GetAdminsNum(chat_id,UserId[2]).pin_messages, GetAdminsNum(chat_id,UserId[2]).promote})
end
end
end
if Text and Text:match('(%d+)/groupNum4//(%d+)') then
local UserId = {Text:match('(%d+)/groupNum4//(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
if tonumber(GetAdminsNum(chat_id,UserId[2]).invite_users) == 1 then
bot.answerCallbackQuery(data.id, "⤈︙ تم تعطيل صلاحيه دعوه المستخدمين", true)
GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id,nil,nil,nil,'❌️',nil,nil)
bot.setChatMemberStatus(chat_id,UserId[2],'administrator',{0 ,GetAdminsNum(chat_id,UserId[2]).change_info, 0, 0, GetAdminsNum(chat_id,UserId[2]).delete_messages, 0, GetAdminsNum(chat_id,UserId[2]).restrict_members ,GetAdminsNum(chat_id,UserId[2]).pin_messages, GetAdminsNum(chat_id,UserId[2]).promote})
else
bot.answerCallbackQuery(data.id, "⤈︙ تم تفعيل صلاحيه دعوه المستخدمين", true)
GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id,nil,nil,nil,'✅️️',nil,nil)
bot.setChatMemberStatus(chat_id,UserId[2],'administrator',{0 ,GetAdminsNum(chat_id,UserId[2]).change_info, 0, 0, GetAdminsNum(chat_id,UserId[2]).delete_messages, 1, GetAdminsNum(chat_id,UserId[2]).restrict_members ,GetAdminsNum(chat_id,UserId[2]).pin_messages, GetAdminsNum(chat_id,UserId[2]).promote})
end
end
end
if Text and Text:match('(%d+)/groupNum5//(%d+)') then
local UserId = {Text:match('(%d+)/groupNum5//(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
if tonumber(GetAdminsNum(chat_id,UserId[2]).delete_messages) == 1 then
bot.answerCallbackQuery(data.id, "⤈︙ تم تعطيل صلاحيه مسح الرسائل", true)
GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id,nil,nil,nil,nil,'❌️',nil)
bot.setChatMemberStatus(chat_id,UserId[2],'administrator',{0 ,GetAdminsNum(chat_id,UserId[2]).change_info, 0, 0, 0, GetAdminsNum(chat_id,UserId[2]).invite_users, GetAdminsNum(chat_id,UserId[2]).restrict_members ,GetAdminsNum(chat_id,UserId[2]).pin_messages, GetAdminsNum(chat_id,UserId[2]).promote})
else
bot.answerCallbackQuery(data.id, "⤈︙ تم تفعيل صلاحيه مسح الرسائل", true)
GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id,nil,nil,nil,nil,'✅️️',nil)
bot.setChatMemberStatus(chat_id,UserId[2],'administrator',{0 ,GetAdminsNum(chat_id,UserId[2]).change_info, 0, 0, 1, GetAdminsNum(chat_id,UserId[2]).invite_users, GetAdminsNum(chat_id,UserId[2]).restrict_members ,GetAdminsNum(chat_id,UserId[2]).pin_messages, GetAdminsNum(chat_id,UserId[2]).promote})
end
end
end
if Text and Text:match('(%d+)/groupNum6//(%d+)') then
local UserId = {Text:match('(%d+)/groupNum6//(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
if tonumber(GetAdminsNum(chat_id,UserId[2]).promote) == 1 then
bot.answerCallbackQuery(data.id, "⤈︙ تم تعطيل صلاحيه اضافه مشرفين", true)
GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id,nil,nil,nil,nil,nil,'❌️')
bot.setChatMemberStatus(chat_id,UserId[2],'administrator',{0 ,GetAdminsNum(chat_id,UserId[2]).change_info, 0, 0, GetAdminsNum(chat_id,UserId[2]).delete_messages, GetAdminsNum(chat_id,UserId[2]).invite_users, GetAdminsNum(chat_id,UserId[2]).restrict_members ,GetAdminsNum(chat_id,UserId[2]).pin_messages, 0})
else
bot.answerCallbackQuery(data.id, "⤈︙ تم تفعيل صلاحيه اضافه مشرفين", true)
GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id,nil,nil,nil,nil,nil,'✅️️')
bot.setChatMemberStatus(chat_id,UserId[2],'administrator',{0 ,GetAdminsNum(chat_id,UserId[2]).change_info, 0, 0, GetAdminsNum(chat_id,UserId[2]).delete_messages, GetAdminsNum(chat_id,UserId[2]).invite_users, GetAdminsNum(chat_id,UserId[2]).restrict_members ,GetAdminsNum(chat_id,UserId[2]).pin_messages, 1})
end
end
end

if Text and Text:match("^mn_(.*)_(.*)") then
local infomsg = {Text:match("^mn_(.*)_(.*)")}
local userid = infomsg[1]
local Type  = infomsg[2]
if tonumber(data.sender_user_id) ~= tonumber(userid) then  
return bot.answerCallbackQuery(data.id,"⤈︙ عذراً عذراً الامر لا يخصك ", true)
end
if Type == "st" then  
ty =  "الملصقات الممنوعه"
Info_ = redis:smembers(bot_id.."mn:content:Sticker"..data.chat_id)  
t = "⤈︙ قائمه "..ty.." ."
if #Info_ == 0 then
return bot.answerCallbackQuery(data.id,"⤈︙ قائمه "..ty.." فارغه ", true)
end  
bot.answerCallbackQuery(data.id,"⤈︙ تم مسحها ", true)
redis:del(bot_id.."mn:content:Sticker"..data.chat_id) 
elseif Type == "tx" then  
ty =  "الكلمات الممنوعه"
Info_ = redis:smembers(bot_id.."mn:content:Text"..data.chat_id)  
t = "⤈︙ قائمه "..ty.." ."
if #Info_ == 0 then
return bot.answerCallbackQuery(data.id,"⤈︙ قائمه "..ty.." فارغه ", true)
end  
bot.answerCallbackQuery(data.id,"⤈︙ تم مسحها ", true)
redis:del(bot_id.."mn:content:Text"..data.chat_id) 
elseif Type == "gi" then  
 ty =  "المتحركه الممنوعه"
Info_ = redis:smembers(bot_id.."mn:content:Animation"..data.chat_id)  
t = "⤈︙ قائمه "..ty.." ."
if #Info_ == 0 then
return bot.answerCallbackQuery(data.id,"⤈︙ قائمه "..ty.." فارغه ", true)
end  
bot.answerCallbackQuery(data.id,"⤈︙ تم مسحها ", true)
redis:del(bot_id.."mn:content:Animation"..data.chat_id) 
elseif Type == "ph" then  
ty =  "الصور الممنوعه"
Info_ = redis:smembers(bot_id.."mn:content:Photo"..data.chat_id) 
t = "⤈︙ قائمه "..ty.." ."
if #Info_ == 0 then
return bot.answerCallbackQuery(data.id,"⤈︙ قائمه "..ty.." فارغه ", true)
end  
bot.answerCallbackQuery(data.id,"⤈︙ تم مسحها ", true)
redis:del(bot_id.."mn:content:Photo"..data.chat_id) 
elseif Type == "up" then  
local Photo =redis:scard(bot_id.."mn:content:Photo"..data.chat_id) 
local Animation =redis:scard(bot_id.."mn:content:Animation"..data.chat_id)  
local Sticker =redis:scard(bot_id.."mn:content:Sticker"..data.chat_id)  
local Text =redis:scard(bot_id.."mn:content:Text"..data.chat_id)  
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = 'الصور الممنوعه', data="mn_"..data.sender_user_id.."_ph"},{text = 'الكلمات الممنوعه', data="mn_"..data.sender_user_id.."_tx"}},
{{text = 'المتحركه الممنوعه', data="mn_"..data.sender_user_id.."_gi"},{text = 'الملصقات الممنوعه',data="mn_"..data.sender_user_id.."_st"}},
{{text = 'تحديث',data="mn_"..data.sender_user_id.."_up"}},
}
}
bot.editMessageText(chat_id,msg_id,"*⤈︙ تحوي قائمه المنع على :\n⤈︙ الصور ( "..Photo.." )\n⤈︙ الكلمات ( "..Text.." )\n⤈︙ الملصقات ( "..Sticker.." )\n⤈︙ المتحركه ( "..Animation.." )\n⤈︙ اضغط على القائمه المراد مسحها*", 'md', true, false, reply_markup)
bot.answerCallbackQuery(data.id,"تم تحديث النتائج", true)
end
end
if Text == 'EndAddarrayy'..user_id then  
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}},
}
}
if redis:get(bot_id..'Set:arrayy'..user_id..':'..chat_id) == 'true1' then
redis:del(bot_id..'Set:arrayy'..user_id..':'..chat_id)
bot.editMessageText(chat_id,msg_id,"*⤈︙ تم حفظ الردود *", 'md', true, false, reply_markup)
else
bot.editMessageText(chat_id,msg_id,"*⤈︙ تم تنفيذ الامر سابقاً*", 'md', true, false, reply_markup)
end
end
if Text == 'EndAddarray'..user_id then  
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}},
}
}
if redis:get(bot_id..'Set:array'..user_id..':'..chat_id) == 'true1' then
redis:del(bot_id..'Set:array'..user_id..':'..chat_id)
bot.editMessageText(chat_id,msg_id,"*⤈︙ تم حفظ الردود *", 'md', true, false, reply_markup)
else
bot.editMessageText(chat_id,msg_id,"*⤈︙ تم تنفيذ الامر سابقاً*", 'md', true, false, reply_markup)
end
end
if Text and Text:match("^delforme_(.*)_(.*)") then
local infomsg = {Text:match("^delforme_(.*)_(.*)")}
local userid = infomsg[1]
local Type  = infomsg[2]
if tonumber(data.sender_user_id) ~= tonumber(userid) then  
return bot.answerCallbackQuery(data.id,"⤈︙ عذراً الامر لا يخصك ", true)
end
if Type == "1" then
redis:del(bot_id..":"..chat_id..":"..user_id..":message")
yrv = "رسائلك"
elseif Type == "2" then
redis:del(bot_id..":"..chat_id..":"..user_id..":Editmessage")
yrv = "سحكاتك"
elseif Type == "3" then
redis:del(bot_id..":"..chat_id..":"..user_id..":Addedmem")
yrv = "جهاتك"
elseif Type == "4" then
redis:del(bot_id..":"..chat_id..":"..user_id..":game")
yrv = "نقاطك"
end
bot.answerCallbackQuery(data.id,"تم مسح "..yrv.." بنجاح .", true)
end
if Text and Text:match("^iforme_(.*)_(.*)") then
local infomsg = {Text:match("^iforme_(.*)_(.*)")}
local userid = infomsg[1]
local Type  = infomsg[2]
if tonumber(data.sender_user_id) ~= tonumber(userid) then  
return bot.answerCallbackQuery(data.id,"⤈︙ عذراً الامر لا يخصك ", true)
end
if Type == "1" then
yrv = "رسائلك"
elseif Type == "2" then
yrv = "سحكاتك"
elseif Type == "3" then
yrv = "جهاتك"
elseif Type == "4" then
yrv = "نقاطك"
end
bot.answerCallbackQuery(data.id,"شستفاديت عود من شفت "..yrv.." بس كلي .", true)
end
if Text and Text:match("^Sur_(.*)_(.*)") then
local infomsg = {Text:match("^Sur_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "⤈︙ عذراً الامر لا يخصك", true)
return false
end   
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ‹ Source Time › ⁦ ',url="t.me/YAYYYYYY"}},
}
}
if tonumber(infomsg[2]) == 1 then
if GetInfoBot(data).BanUser == false then
bot.editMessageText(chat_id,msg_id,"*⤈︙ لا يمتلك البوت صلاحيه حظر الاعضاء*", 'md', true, false, reply_markup)
return false
end   
if not Isrank(data.sender_user_id,chat_id) then
t = "*⤈︙ لا يمكن للبوت حظر "..Get_Rank(data.sender_user_id,chat_id).."*"
else
t = "*⤈︙ تم طردك *"
bot.setChatMemberStatus(chat_id,data.sender_user_id,'banned',0)
end
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_markup)
elseif tonumber(infomsg[2]) == 2 then
bot.editMessageText(chat_id,msg_id,"*⤈︙ تم الغاء العمليه بنجاح .*", 'md', true, false, reply_markup)
end
end
if Text and Text:match("^Amr_(.*)_(.*)") then
local infomsg = {Text:match("^Amr_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "⤈︙ عذراً الامر لا يخصك .", true)
return false
end   
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "‹ 1 ›" ,data="Amr_"..data.sender_user_id.."_1"},{text ="‹ 2 ›",data="Amr_"..data.sender_user_id.."_2"}},
{{text ="‹ 3 ›",data="Amr_"..data.sender_user_id.."_3"}},
{{text ="‹ 4 ›",data="Amr_"..data.sender_user_id.."_4"},{text ="‹ 5 ›",data="Amr_"..data.sender_user_id.."_5"}},
{{text ="‹ 6 ›",data="Amr_"..data.sender_user_id.."_6"},{text ="‹ 7 ›",data="Amr_"..data.sender_user_id.."_7"}},
{{text = '‹ رجوع ›',data="Amr_"..data.sender_user_id.."_8"}},
}
}
if infomsg[2] == '1' then
reply_markup = reply_markup
t = "*⤈︙ اوامر القفل - الفتح .\n *ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ *\n⤈︙ قفل - فتح - الامر .\n⤈︙ تستطيع قفل الحمايه .\n⤈︙ ( بالتقيد - بالطرد - بالكتم - بالتقييد ) .\n *ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ *\n⤈︙ تاك .\n⤈︙ القناه .\n⤈︙ الصور .\n⤈︙ الرابط .\n⤈︙ السب .\n⤈︙ الموقع .\n⤈︙ التكرار .\n⤈︙ الفيديو .\n⤈︙ الدخول .\n⤈︙ الاضافه .\n⤈︙ الاغاني .\n⤈︙ الصوت .\n⤈︙ الملفات .\n⤈︙ الرسائل .\n⤈︙ الدردشه .\n⤈︙ الجهات .\n⤈︙ السيلفي .\n⤈︙ التثبيت .\n⤈︙ الشارحه .\n⤈︙ الكلايش .\n⤈︙ البوتات .\n⤈︙ التوجيه .\n⤈︙ التعديل .\n⤈︙ الانلاين .\n⤈︙ المعرفات .\n⤈︙ الكيبورد .\n⤈︙ الفارسيه .\n⤈︙ الانكليزيه .\n⤈︙ الاستفتاء .\n⤈︙ الملصقات .\n⤈︙ الاشعارات .\n⤈︙ الماركداون .\n⤈︙ المتحركات .*"
elseif infomsg[2] == '2' then
reply_markup = reply_markup
t = "*⤈︙ اعدادات المجموعه .\n *ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ *\n⤈︙ الترحيب .\n⤈︙ مسح الرتب .\n⤈︙ الغاء التثبيت .\n⤈︙ فحص البوت .\n⤈︙ تعين الرابط .\n⤈︙ مسح الرابط .\n⤈︙ تغيير الايدي .\n⤈︙ تعين الايدي .\n⤈︙ مسح الايدي .\n⤈︙ مسح الترحيب .\n⤈︙ صورتي .\n⤈︙ تغيير اسم المجموعه .\n⤈︙ تعين قوانين .\n⤈︙ تغيير الوصف .\n⤈︙ مسح القوانين .\n⤈︙ مسح الرابط .\n⤈︙ تنظيف التعديل .\n⤈︙ تنظيف الميديا .\n⤈︙ مسح الرابط .\n⤈︙ رفع الادمنيه .\n⤈︙ تعين ترحيب .\n⤈︙ ٴall .\n⤈︙ منشن .\n⤈︙ منشن للكل .\n⤈︙ منشن ايموجي .\n⤈︙ الترحيب .\n⤈︙ التحقق .\n⤈︙ المجموعه .\n⤈︙ انذار .\n⤈︙ رفع مشرف .\n⤈︙ اضف رد انلاين .\n⤈︙ اطردني .\n⤈︙ نزلني .\n⤈︙ لقبي .\n⤈︙ كشف المجموعه .\n⤈︙ المتفاعلين .\n⤈︙ مسح الرتب .\n⤈︙ ابلاغ .\n⤈︙ المجموعه .\n⤈︙ الرابط .\n⤈︙ مسح بالرد .\n⤈︙ رتبتي .\n⤈︙ ضع رتبه تحكم .\n⤈︙ رفع المالك .\n⤈︙ المالك .\n⤈︙ منع بالرد .\n⤈︙ منع .\n⤈︙ مسح + عدد .\n⤈︙ قائمه المنع .\n⤈︙ مسح قائمه المنع .\n⤈︙ مسح الاوامر المضافه .\n⤈︙ الاوامر المضافه .\n⤈︙ ترتيب الاوامر .\n⤈︙ اضف امر .\n⤈︙ مسح امر .\n⤈︙ اضف رد .\n⤈︙ مسح رد .\n⤈︙ الردود .\n⤈︙ مسح الردود .\n⤈︙ الردود المتعدده .\n⤈︙ مسح الردود المتعدده .\n⤈︙ وضع عدد المسح + رقم .\n⤈︙ مسح البوتات .\n⤈︙ تغير رد ( العضو - المميز - الادمن - المدير - المنشئ - المنشئ الاساسي - المالك - المطور ) \n⤈︙ مسح رد ( العضو - المميز - الادمن - المدير - المنشئ - المنشئ الاساسي - المالك - المطور ) *"
elseif infomsg[2] == '3' then
reply_markup = reply_markup
t = "*⤈︙ اوامر التفعيل والتعطيل .\n *ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ *\n⤈︙ اوامر التسليه .\n⤈︙ الالعاب المتطوره .\n⤈︙ الطرد .\n⤈︙ الحظر .\n⤈︙ الرفع .\n⤈︙ الترفيه .\n⤈︙ المسح التلقائي .\n⤈︙ ٴall .\n⤈︙ مين ضافني .\n⤈︙ ردود البوت .\n⤈︙ الايدي بالصوره .\n⤈︙ الايدي .\n⤈︙ التنظيف .\n⤈︙ الترحيب .\n⤈︙ الرابط .\n⤈︙ البايو .\n⤈︙ ضع رتبه .\n⤈︙ افتاري .\n⤈︙ الالعاب .\n⤈︙ اوامر النسب .\n⤈︙ تتزوجيني .\n⤈︙ زوجني .\n⤈︙ انا مين .\n⤈︙ شبيهي .\n⤈︙ الانذارات .\n⤈︙ شخصيتي .\n⤈︙ ثنائي .\n⤈︙ اليوتيوب .\n⤈︙ التاك .\n⤈︙ نزلني .\n⤈︙ قولي .\n⤈︙ الزخرفه .\n⤈︙ الابراج .\n⤈︙ معاني الاسماء .\n⤈︙ حساب العمر .*"
elseif infomsg[2] == '4' then
reply_markup = reply_markup
t = "*⤈︙ اوامر اخرى .\n *ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉  *\n⤈︙ ( الالعاب الاحترافيه )\n⤈︙ ( المجموعه )\n⤈︙ ( الرابط )\n⤈︙ ( اسمي )\n⤈︙ ( ايديي )\n⤈︙ ( مسح نقاطي )\n⤈︙ ( نقاطي )\n⤈︙ ( مسح رسائلي )\n⤈︙ ( رسائلي )\n⤈︙ ( مسح جهاتي )\n⤈︙ ( مسح بالرد  )\n⤈︙ ( تفاعلي )\n⤈︙ ( جهاتي )\n⤈︙ ( مسح سحكاتي )\n⤈︙ ( سحكاتي )\n⤈︙ ( رتبتي )\n⤈︙ ( معلوماتي )\n⤈︙ ( المنشئ )\n⤈︙ ( رفع المنشئ )\n⌁  :( غنيلي، فلم، متحركه، رمزيه، فيديو )\n⌁ )  :( البايو/نبذتي )\n⤈︙ ( التاريخ/الساعه )\n⤈︙ ( رابط الحذف )\n⤈︙ ( الالعاب )*"
elseif infomsg[2] == '5' then
reply_markup = reply_markup
t = "*:( تغير رد {العضو. المميز. الادمن. المدير. المنشئ. المنشئ الاساسي. المالك. المطور } ) \n⤈︙ ( حذف رد {العضو. المميز. الادمن. المدير. المنشئ. المنشئ الاساسي. المالك. المطور}  :( منع بالرد )\n⤈︙ ( منع )\n⤈︙ ( تنظيف + عدد )\n⤈︙ ( قائمه المنع )\n⤈︙ ( مسح قائمه المنع )\n⤈︙ ( مسح الاوامر المضافه )\n⤈︙ ( الاوامر المضافه )\n⤈︙ ( ترتيب الاوامر )\n⤈︙ ( اضف امر )\n⤈︙ ( حذف امر )\n⤈︙ ( اضف رد )\n⤈︙ ( حذف رد )\n⤈︙ ( ردود المدير )\n⤈︙ ( مسح ردود المدير )\n⤈︙ ( الردود المتعدده )\n⤈︙ ( مسح الردود المتعدده )\n⤈︙ ( وضع عدد المسح +رقم )\n⤈︙ ( مسح البوتات )\n⤈︙ ( ٴall )\n*"
elseif infomsg[2] == '6' then
reply_markup = reply_markup
t = "*⤈︙ اوامر التسليه \n *ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ *\n⤈︙ الالعاب \n⤈︙ الالعاب المتطوره\n⤈︙ برج اسم برجك \n⤈︙ زخرفه النص\n⤈︙ احسب عمرك\n⤈︙ بحث + اسم الاغنية\n⤈︙ ثنائي\n⤈︙ فلم\n⤈︙ غنيلي\n⤈︙ تحدي\n⤈︙ زوجيني\n⤈︙ افتاري\n⤈︙ استوري\n⤈︙ ميمز \n⤈︙ قولي + الكلام\n⤈︙ قيف\n⤈︙ افتار\n⤈︙ افتارات عيال\n⤈︙ افتارات بنات\n⤈︙ تتزوجيني\n⤈︙ انا مين\n⤈︙ قولي - الكلام \n⤈︙ كت تويت : كت : كت\n⤈︙ ٴId\n⤈︙ همسه\n⤈︙ صراحه\n⤈︙ لو خيروك\n⤈︙ نادي المطور\n⤈︙ يوزري\n⤈︙ اسمي\n⤈︙ البايو\n⤈︙ شخصيتي\n⤈︙ لقبي\n⤈︙ ايديي\n⤈︙ مسح نقاطي \n⤈︙ نقاطي\n⤈︙ مسح رسائلي \n⤈︙ رسائلي\n⤈︙ مسح جهاتي \n⤈︙ تفاعلي\n⤈︙ جهاتي\n⤈︙ مسح تعديلاتي \n⤈︙ تعديلاتي  \n⤈︙ معلوماتي \n⤈︙ التاريخ/الساعه \n⤈︙ رابط الحذف\n⤈︙ جمالي\n⤈︙ نسبه الحب - الكره\n⤈︙ نسبه الذكاء - الغباء \n⤈︙ نسبه الرجوله - الانوثه\n*"
elseif infomsg[2] == '7' then
reply_markup = reply_markup
t = "*⤈︙ قائمه العاب سورس تريكس .\nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⤈︙ لعبة حجرة ورقة مقص - حجره .\n⤈︙ لعبة الرياضه - رياضه .\n⤈︙ لعبة معرفة الصورة - صور .\n⤈︙ لعبة معرفة الموسيقى - موسيقى .\n⤈︙ لعبة المشاهير - مشاهير .\n⤈︙ لعبة العكس - العكس .\n⤈︙ لعبة الحزوره - حزوره .\n⤈︙ لعبة المعاني - معاني .\n⤈︙ لعبة البات - بات .\n⤈︙ لعبة التخمين - خمن .\n⤈︙ لعبه الاسرع - الاسرع .\n⤈︙ لعبه الترجمه - انكليزي .\n⤈︙ لعبه تفكيك الكلمه - تفكيك .\n⤈︙ لعبه تركيب الكلمه - تركيب .\n⤈︙ لعبه الرياضيات - رياضيات .\n⤈︙ لعبة السمايلات - سمايلات .\n⤈︙ لعبة العواصم - العواصم .\n⤈︙ لعبة الارقام - ارقام .\n⤈︙ لعبة الحروف - حروف .\n⤈︙ كت تويت - كت .\n⤈︙ لعبة الاعلام والدول - اعلام .\n⤈︙ لعبة الصراحه - صراحه .\n⤈︙ لعبة الروليت - روليت .\n⤈︙ لعبة احكام - احكام .\n⤈︙ لعبة العقاب - عقاب .\n⤈︙ لعبة الكلمات - كلمات .\nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ \n⤈︙ نقاطي - لعرض عدد نقاطك .\n⤈︙ بيع نقاطي + العدد لبيع كل نقطه مقابل 50 رساله .*"
elseif infomsg[2] == '8' then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "‹ 1 ›" ,data="Amr_"..data.sender_user_id.."_1"},{text ="‹ 2 ›",data="Amr_"..data.sender_user_id.."_2"}},
{{text ="‹ 3 ›",data="Amr_"..data.sender_user_id.."_3"}},
{{text ="‹ 4 ›",data="Amr_"..data.sender_user_id.."_4"},{text ="‹ 5 ›",data="Amr_"..data.sender_user_id.."_5"}},
{{text ="‹ 6 ›",data="Amr_"..data.sender_user_id.."_6"},{text ="‹ 7 ›",data="Amr_"..data.sender_user_id.."_7"}},
{{text = '‹ اخفاء ›', data = data.sender_user_id..'/delAmr'}}, 
}
}
t ="*⤈︙ اوامر البوت الرئيسيه .\n * ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*\n⤈︙ م1 - اوامر الحمايه .\n⤈︙ م2 - اوامر الاعدادات .\n⤈︙ م3 - اوامر المدراء .\n⤈︙ م4 - اوامر اخرى .\n⤈︙ م5 - اوامر المالكين .\n⤈︙ م6 - اوامر التسليه .\n⤈︙ م7 - العاب السورس .*"
end
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_markup)
end
if Text and Text:match("^Ammr_(.*)_(.*)") then
local infomsg = {Text:match("^Ammr_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "⤈︙ عذراً الامر لا يخصك .", true)
return false
end   
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "‹ العاب السورس ›" ,data="Ammr_"..data.sender_user_id.."_20"}},
{{text = '‹ رجوع ›',data="Ammr_"..data.sender_user_id.."_21"}},
}
}
if infomsg[2] == '20' then
reply_markup = reply_markup
t = "*⤈︙ قائمه العاب سورس تريكس .\nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⤈︙ لعبة حجرة ورقة مقص - حجره .\n⤈︙ لعبة الرياضه - رياضه .\n⤈︙ لعبة معرفة الصورة - صور .\n⤈︙ لعبة معرفة الموسيقى - موسيقى .\n⤈︙ لعبة المشاهير - مشاهير .\n⤈︙ لعبة العكس - العكس .\n⤈︙ لعبة الحزوره - حزوره .\n⤈︙ لعبة المعاني - معاني .\n⤈︙ لعبة البات - بات .\n⤈︙ لعبة التخمين - خمن .\n⤈︙ لعبه الاسرع - الاسرع .\n⤈︙ لعبه الترجمه - انكليزي .\n⤈︙ لعبه تفكيك الكلمه - تفكيك .\n⤈︙ لعبه تركيب الكلمه - تركيب .\n⤈︙ لعبه الرياضيات - رياضيات .\n⤈︙ لعبة السمايلات - سمايلات .\n⤈︙ لعبة العواصم - العواصم .\n⤈︙ لعبة الارقام - ارقام .\n⤈︙ لعبة الحروف - حروف .\n⤈︙ كت تويت - كت .\n⤈︙ لعبة الاعلام والدول - اعلام .\n⤈︙ لعبة الصراحه - صراحه .\n⤈︙ لعبة الروليت - روليت .\n⤈︙ لعبة احكام - احكام .\n⤈︙ لعبة العقاب - عقاب .\n⤈︙ لعبة الكلمات - كلمات .\nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ \n⤈︙ نقاطي - لعرض عدد نقاطك .\n⤈︙ بيع نقاطي + العدد لبيع كل نقطه مقابل 50 رساله .*"
elseif infomsg[2] == '21' then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "‹ العاب السورس ›" ,data="Ammr_"..data.sender_user_id.."_20"}},
{{text = '‹ اخفاء ›', data = data.sender_user_id..'/delAmr'}}, 
}
}
t ="*⤈︙ اهلا بك عزيزي الادمن . \n⤈︙ قائمه العاب السورس في الإسفل .*"
end
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_markup)
end
----------------------------------------------------------------------------------------------------
if Text and Text:match("^GetSeBk_(.*)_(.*)") then
local infomsg = {Text:match("^GetSeBk_(.*)_(.*)")}
num = tonumber(infomsg[1])
any = tonumber(infomsg[2])
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "⤈︙ عذراً الامر لا يخصك .", true)
return false
end  
if any == 0 then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "‹ الكيبورد ›" ,data="GetSe_"..user_id.."_Keyboard"},{text = GetSetieng(chat_id).Keyboard ,data="GetSe_"..user_id.."_Keyboard"}},
{{text = "‹ الملصقات ›" ,data="GetSe_"..user_id.."_messageSticker"},{text =GetSetieng(chat_id).messageSticker,data="GetSe_"..user_id.."_messageSticker"}},
{{text = "‹ الاغاني ›" ,data="GetSe_"..user_id.."_messageVoiceNote"},{text =GetSetieng(chat_id).messageVoiceNote,data="GetSe_"..user_id.."_messageVoiceNote"}},
{{text = "‹ الانكليزي ›" ,data="GetSe_"..user_id.."_WordsEnglish"},{text =GetSetieng(chat_id).WordsEnglish,data="GetSe_"..user_id.."_WordsEnglish"}},
{{text = "‹ الفارسيه ›" ,data="GetSe_"..user_id.."_WordsPersian"},{text =GetSetieng(chat_id).WordsPersian,data="GetSe_"..user_id.."_WordsPersian"}},
{{text = "‹ الدخول ›" ,data="GetSe_"..user_id.."_JoinByLink"},{text =GetSetieng(chat_id).JoinByLink,data="GetSe_"..user_id.."_JoinByLink"}},
{{text = "‹ الصور ›" ,data="GetSe_"..user_id.."_messagePhoto"},{text =GetSetieng(chat_id).messagePhoto,data="GetSe_"..user_id.."_messagePhoto"}},
{{text = "‹ الفيديو ›" ,data="GetSe_"..user_id.."_messageVideo"},{text =GetSetieng(chat_id).messageVideo,data="GetSe_"..user_id.."_messageVideo"}},
{{text = "‹ الجهات ›" ,data="GetSe_"..user_id.."_messageContact"},{text =GetSetieng(chat_id).messageContact,data="GetSe_"..user_id.."_messageContact"}},
{{text = "‹ السلفي ›" ,data="GetSe_"..user_id.."_messageVideoNote"},{text =GetSetieng(chat_id).messageVideoNote,data="GetSe_"..user_id.."_messageVideoNote"}},
{{text = "↪️" ,data="GetSeBk_"..user_id.."_1"}},
}
}
elseif any == 1 then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "‹ الاستفتاء ›" ,data="GetSe_"..user_id.."_messagePoll"},{text =GetSetieng(chat_id).messagePoll,data="GetSe_"..user_id.."_messagePoll"}},
{{text = "‹ الصوت ›" ,data="GetSe_"..user_id.."_messageAudio"},{text =GetSetieng(chat_id).messageAudio,data="GetSe_"..user_id.."_messageAudio"}},
{{text = "‹ الملفات ›" ,data="GetSe_"..user_id.."_messageDocument"},{text =GetSetieng(chat_id).messageDocument,data="GetSe_"..user_id.."_messageDocument"}},
{{text = "‹ المتحركات ›" ,data="GetSe_"..user_id.."_messageAnimation"},{text =GetSetieng(chat_id).messageAnimation,data="GetSe_"..user_id.."_messageAnimation"}},
{{text = "‹ الاضافه ›" ,data="GetSe_"..user_id.."_AddMempar"},{text =GetSetieng(chat_id).AddMempar,data="GetSe_"..user_id.."_AddMempar"}},
{{text = "‹ التثبيت ›" ,data="GetSe_"..user_id.."_messagePinMessage"},{text =GetSetieng(chat_id).messagePinMessage,data="GetSe_"..user_id.."_messagePinMessage"}},
{{text = "‹ القناه ›" ,data="GetSe_"..user_id.."_messageSenderChat"},{text = GetSetieng(chat_id).messageSenderChat ,data="GetSe_"..user_id.."_messageSenderChat"}},
{{text = "‹ الشارحه ›" ,data="GetSe_"..user_id.."_Cmd"},{text =GetSetieng(chat_id).Cmd,data="GetSe_"..user_id.."_Cmd"}},
{{text = "‹ الموقع ›" ,data="GetSe_"..user_id.."_messageLocation"},{text = GetSetieng(chat_id).messageLocation ,data="GetSe_"..user_id.."_messageLocation"}},
{{text = "‹ التكرار ›" ,data="GetSe_"..user_id.."_flood"},{text = GetSetieng(chat_id).flood ,data="GetSe_"..user_id.."_flood"}},
{{text = "↩️" ,data="GetSeBk_"..user_id.."_0"},{text = "↪️" ,data="GetSeBk_"..user_id.."_2"}},
}
}
elseif any == 2 then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "‹ الكلايش ›" ,data="GetSe_"..user_id.."_Spam"},{text =GetSetieng(chat_id).Spam,data="GetSe_"..user_id.."_Spam"}},
{{text = "‹ التعديل ›" ,data="GetSe_"..user_id.."_Edited"},{text = GetSetieng(chat_id).Edited ,data="GetSe_"..user_id.."_Edited"}},
{{text = "‹ التاك ›" ,data="GetSe_"..user_id.."_Hashtak"},{text =GetSetieng(chat_id).Hashtak,data="GetSe_"..user_id.."_Hashtak"}},
{{text = "‹ الانلاين ›" ,data="GetSe_"..user_id.."_viabotuserid"},{text = GetSetieng(chat_id).via_bot_user_id ,data="GetSe_"..user_id.."_viabotuserid"}},
{{text = "‹ البوتات ›" ,data="GetSe_"..user_id.."_messageChatAddMembers"},{text =GetSetieng(chat_id).messageChatAddMembers,data="GetSe_"..user_id.."_messageChatAddMembers"}},
{{text = "‹ التوجيه ›" ,data="GetSe_"..user_id.."_forwardinfo"},{text = GetSetieng(chat_id).forward_info ,data="GetSe_"..user_id.."_forwardinfo"}},
{{text = "‹ الروابط ›" ,data="GetSe_"..user_id.."_Links"},{text =GetSetieng(chat_id).Links,data="GetSe_"..user_id.."_Links"}},
{{text = "‹ الماركداون ›" ,data="GetSe_"..user_id.."_Markdaun"},{text = GetSetieng(chat_id).Markdaun ,data="GetSe_"..user_id.."_Markdaun"}},
{{text = "‹ الفشار ›" ,data="GetSe_"..user_id.."_WordsFshar"},{text =GetSetieng(chat_id).WordsFshar,data="GetSe_"..user_id.."_WordsFshar"}},
{{text = "‹ الاشعارات ›" ,data="GetSe_"..user_id.."_Tagservr"},{text = GetSetieng(chat_id).Tagservr ,data="GetSe_"..user_id.."_Tagservr"}},
{{text = "‹ المعرفات ›" ,data="GetSe_"..user_id.."_Username"},{text =GetSetieng(chat_id).Username,data="GetSe_"..user_id.."_Username"}},
{{text = "↩️" ,data="GetSeBk_"..user_id.."_1"},{text = "↪️" ,data="GetSeBk_"..user_id.."_3"}},
}
}
elseif any == 3 then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "‹ اطردني ›" ,data="GetSe_"..user_id.."_kickme"},{text =redis_get(chat_id,"kickme"),data="GetSe_"..user_id.."_kickme"}},
{{text = "‹ البايو ›" ,data="GetSe_"..user_id.."_GetBio"},{text =redis_get(chat_id,"GetBio"),data="GetSe_"..user_id.."_GetBio"}},
{{text = "‹ الرابط ›" ,data="GetSe_"..user_id.."_link"},{text =redis_get(chat_id,"link"),data="GetSe_"..user_id.."_link"}},
{{text = "‹ الترحيب ›" ,data="GetSe_"..user_id.."_Welcome"},{text =redis_get(chat_id,"Welcome"),data="GetSe_"..user_id.."_Welcome"}},
{{text = "‹ الايدي ›" ,data="GetSe_"..user_id.."_id"},{text =redis_get(chat_id,"id"),data="GetSe_"..user_id.."_id"}},
{{text = "‹ الايدي بالصوره ›" ,data="GetSe_"..user_id.."_id:ph"},{text =redis_get(chat_id,"id:ph"),data="GetSe_"..user_id.."_id:ph"}},
{{text = "‹ التنضيف ›" ,data="GetSe_"..user_id.."_delmsg"},{text =redis_get(chat_id,"delmsg"),data="GetSe_"..user_id.."_delmsg"}},
{{text = "‹ التسليه ›" ,data="GetSe_"..user_id.."_entertainment"},{text =redis_get(chat_id,"entertainment"),data="GetSe_"..user_id.."_entertainment"}},
{{text = "‹ الالعاب الاحترافيه ›" ,data="GetSe_"..user_id.."_gameVip"},{text =redis_get(chat_id,"gameVip"),data="GetSe_"..user_id.."_gameVip"}},
{{text = "‹ منو ضافني ›" ,data="GetSe_"..user_id.."_addme"},{text =redis_get(chat_id,"addme"),data="GetSe_"..user_id.."_addme"}},
{{text = "‹ ردود المدير ›" ,data="GetSe_"..user_id.."_Reply"},{text =redis_get(chat_id,"Reply"),data="GetSe_"..user_id.."_Reply"}},
{{text = "‹ الالعاب ›" ,data="GetSe_"..user_id.."_game"},{text =redis_get(chat_id,"game"),data="GetSe_"..user_id.."_game"}},
{{text = "‹ صورتي ›" ,data="GetSe_"..user_id.."_phme"},{text =redis_get(chat_id,"phme"),data="GetSe_"..user_id.."_phme"}},
{{text = "↩️" ,data="GetSeBk_"..user_id.."_2"}}
}
}
end
bot.editMessageText(chat_id,msg_id,"*⤈︙ اعدادات المجموعه .\n⤈︙ اوامر القفل - والفتح .*", 'md', true, false, reply_markup)
end
if Text and Text:match("^GetSe_(.*)_(.*)") then
local infomsg = {Text:match("^GetSe_(.*)_(.*)")}
ifd = infomsg[1]
Amr = infomsg[2]
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "⤈︙ عذراً الامر لا يخصك .", true)
return false
end  
if Amr == "viabotuserid" then 
Amr "via_bot_user_id"
elseif Amr == "forwardinfo" then
Amr "forward_info"
else
Amr = Amr
end
if not redis:get(bot_id..":"..chat_id..":settings:"..Amr) then
redis:set(bot_id..":"..chat_id..":settings:"..Amr,"del")    
elseif redis:get(bot_id..":"..chat_id..":settings:"..Amr) == "del" then 
redis:set(bot_id..":"..chat_id..":settings:"..Amr,"ktm")    
elseif redis:get(bot_id..":"..chat_id..":settings:"..Amr) == "ktm" then 
redis:set(bot_id..":"..chat_id..":settings:"..Amr,"ked")    
elseif redis:get(bot_id..":"..chat_id..":settings:"..Amr) == "ked" then 
redis:set(bot_id..":"..chat_id..":settings:"..Amr,"kick")    
elseif redis:get(bot_id..":"..chat_id..":settings:"..Amr) == "kick" then 
redis:del(bot_id..":"..chat_id..":settings:"..Amr)    
end   
if Amr == "messageVideoNote" or Amr == "messageVoiceNote" or Amr == "messageSticker" or Amr == "Keyboard" or Amr == "JoinByLink" or Amr == "WordsPersian" or Amr == "WordsEnglish" or Amr == "messageContact" or Amr == "messageVideo" or Amr == "messagePhoto" then 
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "‹ الكيبورد ›" ,data="GetSe_"..user_id.."_Keyboard"},{text = GetSetieng(chat_id).Keyboard ,data="GetSe_"..user_id.."_Keyboard"}},
{{text = "‹ الملصقات ›" ,data="GetSe_"..user_id.."_messageSticker"},{text =GetSetieng(chat_id).messageSticker,data="GetSe_"..user_id.."_messageSticker"}},
{{text = "‹ الاغاني ›" ,data="GetSe_"..user_id.."_messageVoiceNote"},{text =GetSetieng(chat_id).messageVoiceNote,data="GetSe_"..user_id.."_messageVoiceNote"}},
{{text = "‹ الانكليزي ›" ,data="GetSe_"..user_id.."_WordsEnglish"},{text =GetSetieng(chat_id).WordsEnglish,data="GetSe_"..user_id.."_WordsEnglish"}},
{{text = "‹ الفارسيه ›" ,data="GetSe_"..user_id.."_WordsPersian"},{text =GetSetieng(chat_id).WordsPersian,data="GetSe_"..user_id.."_WordsPersian"}},
{{text = "‹ الدخول ›" ,data="GetSe_"..user_id.."_JoinByLink"},{text =GetSetieng(chat_id).JoinByLink,data="GetSe_"..user_id.."_JoinByLink"}},
{{text = "‹ الصوت ›" ,data="GetSe_"..user_id.."_messagePhoto"},{text =GetSetieng(chat_id).messagePhoto,data="GetSe_"..user_id.."_messagePhoto"}},
{{text = "‹ الفيديو ›" ,data="GetSe_"..user_id.."_messageVideo"},{text =GetSetieng(chat_id).messageVideo,data="GetSe_"..user_id.."_messageVideo"}},
{{text = "‹ الجهات ›" ,data="GetSe_"..user_id.."_messageContact"},{text =GetSetieng(chat_id).messageContact,data="GetSe_"..user_id.."_messageContact"}},
{{text = "‹ السيلفي ›" ,data="GetSe_"..user_id.."_messageVideoNote"},{text =GetSetieng(chat_id).messageVideoNote,data="GetSe_"..user_id.."_messageVideoNote"}},
{{text = "↪️" ,data="GetSeBk_"..user_id.."_1"}},
}
}
elseif Amr == "messagePoll" or Amr == "messageAudio" or Amr == "messageDocument" or Amr == "messageAnimation" or Amr == "AddMempar" or Amr == "messagePinMessage" or Amr == "messageSenderChat" or Amr == "Cmd" or Amr == "messageLocation" or Amr == "flood" then 
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "‹ الاستفتاء ›" ,data="GetSe_"..user_id.."_messagePoll"},{text =GetSetieng(chat_id).messagePoll,data="GetSe_"..user_id.."_messagePoll"}},
{{text = "‹ الصوت ›" ,data="GetSe_"..user_id.."_messageAudio"},{text =GetSetieng(chat_id).messageAudio,data="GetSe_"..user_id.."_messageAudio"}},
{{text = "‹ الملفات ›" ,data="GetSe_"..user_id.."_messageDocument"},{text =GetSetieng(chat_id).messageDocument,data="GetSe_"..user_id.."_messageDocument"}},
{{text = "‹ المتحركات ›" ,data="GetSe_"..user_id.."_messageAnimation"},{text =GetSetieng(chat_id).messageAnimation,data="GetSe_"..user_id.."_messageAnimation"}},
{{text = "‹ الاضافه ›" ,data="GetSe_"..user_id.."_AddMempar"},{text =GetSetieng(chat_id).AddMempar,data="GetSe_"..user_id.."_AddMempar"}},
{{text = "‹ التثبيت ›" ,data="GetSe_"..user_id.."_messagePinMessage"},{text =GetSetieng(chat_id).messagePinMessage,data="GetSe_"..user_id.."_messagePinMessage"}},
{{text = "‹ القناه ›" ,data="GetSe_"..user_id.."_messageSenderChat"},{text = GetSetieng(chat_id).messageSenderChat ,data="GetSe_"..user_id.."_messageSenderChat"}},
{{text = "‹ الشارحه ›" ,data="GetSe_"..user_id.."_Cmd"},{text =GetSetieng(chat_id).Cmd,data="GetSe_"..user_id.."_Cmd"}},
{{text = "‹ الموقع ›" ,data="GetSe_"..user_id.."_messageLocation"},{text = GetSetieng(chat_id).messageLocation ,data="GetSe_"..user_id.."_messageLocation"}},
{{text = "‹ التكرار ›" ,data="GetSe_"..user_id.."_flood"},{text = GetSetieng(chat_id).flood ,data="GetSe_"..user_id.."_flood"}},
{{text = "↩️" ,data="GetSeBk_"..user_id.."_0"},{text = "↪️" ,data="GetSeBk_"..user_id.."_2"}},
}
}
elseif Amr == "Edited" or Amr == "Spam" or Amr == "Hashtak" or Amr == "viabotuserid" or Amr == "forwardinfo" or Amr == "messageChatAddMembers" or Amr == "Links" or Amr == "Markdaun" or Amr == "Username" or Amr == "Tagservr" or Amr == "WordsFshar" then  
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "‹ الكلايش ›" ,data="GetSe_"..user_id.."_Spam"},{text =GetSetieng(chat_id).Spam,data="GetSe_"..user_id.."_Spam"}},
{{text = "‹ التعديل ›" ,data="GetSe_"..user_id.."_Edited"},{text = GetSetieng(chat_id).Edited ,data="GetSe_"..user_id.."_Edited"}},
{{text = "‹ التاك ›" ,data="GetSe_"..user_id.."_Hashtak"},{text =GetSetieng(chat_id).Hashtak,data="GetSe_"..user_id.."_Hashtak"}},
{{text = "‹ الانلاين ›" ,data="GetSe_"..user_id.."_viabotuserid"},{text = GetSetieng(chat_id).via_bot_user_id ,data="GetSe_"..user_id.."_viabotuserid"}},
{{text = "‹ البوتات ›" ,data="GetSe_"..user_id.."_messageChatAddMembers"},{text =GetSetieng(chat_id).messageChatAddMembers,data="GetSe_"..user_id.."_messageChatAddMembers"}},
{{text = "‹ التوجيه ›" ,data="GetSe_"..user_id.."_forwardinfo"},{text = GetSetieng(chat_id).forward_info ,data="GetSe_"..user_id.."_forwardinfo"}},
{{text = "‹ الروابط ›" ,data="GetSe_"..user_id.."_Links"},{text =GetSetieng(chat_id).Links,data="GetSe_"..user_id.."_Links"}},
{{text = "‹ الماركداون ›" ,data="GetSe_"..user_id.."_Markdaun"},{text = GetSetieng(chat_id).Markdaun ,data="GetSe_"..user_id.."_Markdaun"}},
{{text = "‹ الفشار ›" ,data="GetSe_"..user_id.."_WordsFshar"},{text =GetSetieng(chat_id).WordsFshar,data="GetSe_"..user_id.."_WordsFshar"}},
{{text = "‹ الاشعارات ›" ,data="GetSe_"..user_id.."_Tagservr"},{text = GetSetieng(chat_id).Tagservr ,data="GetSe_"..user_id.."_Tagservr"}},
{{text = "‹ المعرفات ›" ,data="GetSe_"..user_id.."_Username"},{text =GetSetieng(chat_id).Username,data="GetSe_"..user_id.."_Username"}},
{{text = "↩️" ,data="GetSeBk_"..user_id.."_2"},{text = "↪️" ,data="GetSeBk_"..user_id.."_3"}},
}
}
end
bot.editMessageText(chat_id,msg_id,"*⤈︙ اعدادات المجموعه .\n⤈︙ اوامر القفل - والفتح .*", 'md', true, false, reply_markup)
end
---
if redis:sismember(bot_id..":Status:Basic",data.sender_user_id) or devB(data.sender_user_id) then    
if Text == "Can" then
redis:del(bot_id..":set:"..chat_id..":UpfJson") 
redis:del(bot_id..":set:"..chat_id..":send") 
redis:del(bot_id..":set:"..chat_id..":dev") 
redis:del(bot_id..":set:"..chat_id..":namebot") 
redis:del(bot_id..":set:"..chat_id..":start") 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ تغيير المطور الاساسي ›',data="EditDevbot"}},
{{text = '‹ الاحصائيات ›',data="indfo"},{text = '‹ التحديثات ›',data="Updates"}},
{{text = '‹ اعدادات تحكم البوت ›',data="botsettings"}},
{{text = '‹ الاشتراك ›',data="chatmem"},{text = '‹ الاذاعه ›',data="sendtomem"}},
{{text = '‹ النسخ الاحتياطيه ›',data="infoAbg"}},
}
}
bot.editMessageText(chat_id,msg_id,"*⤈︙ اهلا بك في قائمه اوامر المطور الاساسي  .*", 'md', true, false, reply_dev)
end
if Text == "UpfJson" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ رجوع ›',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"* ⤈︙ قم بأعاده ارسال الملف الخاص بالنسخه .*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":UpfJson",true) 
end
if Text == "GetfJson" then
bot.answerCallbackQuery(data.id, "⤈︙ جار ارسال النسخه .", true)
local list = redis:smembers(bot_id..":Groups")
local developer = redis:smembers(bot_id..":Status:developer")
local programmer = redis:smembers(bot_id..":Status:programmer") 
local t = '{"idbot": '..bot_id..',"GrBot":{'  
user_idf = redis:smembers(bot_id..":user_id")
if #user_idf ~= 0 then 
t = t..'"user_id":['
for k,v in pairs(user_idf) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..']'
end
if #list ~= 0 then 
t = t..',"Groups":['
for k,v in pairs(list) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..']'
end
if #programmer ~= 0 then 
t = t..',"programmer":['
for k,v in pairs(programmer) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..']'
end
if #developer ~= 0 then 
t = t..',"developer":['
for k,v in pairs(developer) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..']'
end
t = t..',"Dev":"H.muaed",'
for k,v in pairs(list) do
Creator = redis:smembers(bot_id..":"..v..":Status:Creator")
BasicConstructor = redis:smembers(bot_id..":"..v..":Status:BasicConstructor")
Constructor = redis:smembers(bot_id..":"..v..":Status:Constructor")
Owner = redis:smembers(bot_id..":"..v..":Status:Owner")
Administrator = redis:smembers(bot_id..":"..v..":Status:Administrator")
Vips = redis:smembers(bot_id..":"..v..":Status:Vips")
linkid = v or ''
if k == 1 then
t = t..'"'..v..'":{"info":true,'
else
t = t..',"'..v..'":{"info":true,'
end
if #Creator ~= 0 then 
t = t..'"Creator":['
for k,v in pairs(Creator) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..'],'
end
if #BasicConstructor ~= 0 then 
t = t..'"BasicConstructor":['
for k,v in pairs(BasicConstructor) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..'],'
end
if #Constructor ~= 0 then
t = t..'"Constructor":['
for k,v in pairs(Constructor) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..'],'
end
if #Owner ~= 0 then
t = t..'"Owner":['
for k,v in pairs(Owner) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..'],'
end
if #Administrator ~= 0 then
t = t..'"Administrator":['
for k,v in pairs(Administrator) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..'],'
end
if #Vips ~= 0 then
t = t..'"Vips":['
for k,v in pairs(Vips) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..'],'
end
t = t..'"GroupsId":"'..linkid..'"}' or ''
end
t = t..'}}'
local File = io.open('./'..bot_id..'.json', "w")
File:write(t)
File:close()
bot.sendDocument(chat_id, 0,'./'..bot_id..'.json','⤈︙ عدد مجموعات التي في البوت { '..#list..'}\n⤈︙ عدد  الاعضاء التي في البوت { '..#user_idf..'}\n⤈︙ عدد الثانويين في البوت { '..#programmer..'}\n⤈︙ عدد المطورين في البوت { '..#developer..'}', 'md')
dofile("start.lua")
end
if Text == "Delch" then
if not redis:get(bot_id..":TheCh") then
bot.answerCallbackQuery(data.id, "⤈︙ لم يتم وضع اشتراك في البوت", true)
return false
end
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ رجوع ›',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*⤈︙ تم حذف البوت بنجاح .*", 'md', true, false, reply_markup)
redis:del(bot_id..":TheCh")
end
if Text == "addCh" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ رجوع ›',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*⤈︙ قم برفع البوت ادمن في قناتك ثم قم بأرسل توجيه من القناه الى البوت .*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":addCh",true) 
end
if Text == 'TheCh' then
if not redis:get(bot_id..":TheCh") then
bot.answerCallbackQuery(data.id, "⤈︙ لم يتم وضع اشتراك في البوت .", true)
return false
end
idD = redis:get(bot_id..":TheCh")
Get_Chat = bot.getChat(idD)
Info_Chats = bot.getSupergroupFullInfo(idD)
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = Get_Chat.title,url=Info_Chats.invite_link.invite_link}},
{{text = '‹ رجوع ›',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*⤈︙ الاشتراك الاجباري على القناه اسفل : .*", 'md', true, false, reply_dev)
end  
if Text == "indfo" then
Groups = redis:scard(bot_id..":Groups")   
user_id = redis:scard(bot_id..":user_id") 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ رجوع ›',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*⤈︙ اهلا بك في قسم الاحصائيات \n *ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ *\n⤈︙ عدد المشتركين ( "..user_id.." ) عضو \n⤈︙ عدد المجموعات ( "..Groups.." ) مجموعه *", 'md', true, false, reply_dev)
end
if Text == "chatmem" then
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ اضف اشتراك ›',data="addCh"},{text ="‹ حذف الاشتراك ›",data="Delch"}},
{{text = '‹ الاشتراك ›',data="TheCh"}},
{{text = '‹ رجوع ›',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*⤈︙ اهلا بك في لوحه اوامر الاشتراك الاجباري .*", 'md', true, false, reply_dev)
end
if Text == "EditDevbot" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ رجوع ›',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*⤈︙ قم الان بأرسل ايدي المطور الجديد*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":dev",true) 
end
if Text == "addstarttxt" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ رجوع ›',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*⤈︙ قم الان بأرسل كليشه ستارت الجديده*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":start",true) 
end
if Text == 'lsbnal' then
t = '\n*⤈︙ قائمه محظورين عام  \n  ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ *\n'
local Info_ = redis:smembers(bot_id..":bot:Ban") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, "⤈︙ لا يوجد محظورين بالبوت", true)
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ تغيير المطور الاساسي ›',data="EditDevbot"}},
{{text = '‹ الاحصائيات ›',data="indfo"},{text = '‹ التحديثات ›',data="Updates"}},
{{text = '‹ اعدادات تحكم البوت ›',data="botsettings"}},
{{text = '‹ الاشتراك ›',data="chatmem"},{text = '‹ الاذاعه ›',data="sendtomem"}},
{{text = '‹ النسخ الاحتياطيه ›',data="infoAbg"}},
}
}
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_dev)
end
if Text == 'lsmu' then
t = '\n*⤈︙ قائمه المكتومين عام  \n   ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ *\n'
local Info_ = redis:smembers(bot_id..":bot:silent") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, "⤈︙ لا يوجد مكتومين بالبوت", true)
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ تغيير المطور الاساسي ›',data="EditDevbot"}},
{{text = '‹ الاحصائيات ›',data="indfo"},{text = '‹ التحديثات ›',data="Updates"}},
{{text = '‹ اعدادات تحكم البوت ›',data="botsettings"}},
{{text = '‹ الاشتراك ›',data="chatmem"},{text = '‹ الاذاعه ›',data="sendtomem"}},
{{text = '‹ النسخ الاحتياطيه ›',data="infoAbg"}},
}
}
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_dev)
end
if Text == "delbnal" then
local Info_ = redis:smembers(bot_id..":bot:Ban")
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, "⤈︙  لا يوجد محظورين في البوت .", true)
return false
end  
redis:del(bot_id..":bot:Ban")
bot.answerCallbackQuery(data.id, "⤈︙ تم مسح المحظورين بنجاح .", true)
end
if Text == "delmu" then
local Info_ = redis:smembers(bot_id..":bot:silent")
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, "⤈︙  لا يوجد مكتومين في البوت .", true)
return false
end  
redis:del(bot_id..":bot:silent")
bot.answerCallbackQuery(data.id, "⤈︙ تم مسح المكتومين بنجاح .", true)
end
if Text == 'lspor' then
t = '\n*⤈︙ قائمه الثانويين  \n   ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ *\n'
local Info_ = redis:smembers(bot_id..":Status:programmer") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, "⤈︙ لا يوجد ثانويين بالبوت", true)
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ تغيير المطور الاساسي ›',data="EditDevbot"}},
{{text = '‹ الاحصائيات ›',data="indfo"},{text = '‹ التحديثات ›',data="Updates"}},
{{text = '‹ اعدادات تحكم البوت ›',data="botsettings"}},
{{text = '‹ الاشتراك ›',data="chatmem"},{text = '‹ الاذاعه ›',data="sendtomem"}},
{{text = '‹ النسخ الاحتياطيه ›',data="infoAbg"}},
}
}
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_dev)
end
if Text == 'lsdev' then
t = '\n*⤈︙ قائمه المطورين  \n   ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ *\n'
local Info_ = redis:smembers(bot_id..":Status:developer") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, "⤈︙ لا يوجد مطورين بالبوت", true)
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ تغيير المطور الاساسي ›',data="EditDevbot"}},
{{text = '‹ الاحصائيات ›',data="indfo"},{text = '‹ التحديثات ›',data="Updates"}},
{{text = '‹ اعدادات تحكم البوت ›',data="botsettings"}},
{{text = '‹ الاشتراك ›',data="chatmem"},{text = '‹ الاذاعه ›',data="sendtomem"}},
{{text = '‹ النسخ الاحتياطيه ›',data="infoAbg"}},
}
}
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_dev)
end
if Text == "Updates" then
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ تحديث البوت ›',data="UpBot"},{text = '‹ تحديث السورس ›',data="UpSu"}},
{{text = '‹ قناه التحديثات ›',url="t.me/YSYYYYYY"}},
{{text = '‹ رجوع ›',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*⤈︙ قائمه التحديثات .*", 'md', true, false, reply_dev)
end --
if Text == "botsettings" then
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ تغيير المطور الاساسي ›',data="EditDevbot"}},
{{text = '‹ تغير اسم البوت ›',data="namebot"},{text =(redis:get(bot_id..":namebot") or "‹ حذف اسم البوت ›"),data="delnamebot"}},
{{text = '‹ تغيير كليشه ستارت ›',data="addstarttxt"},{text ="‹ حذف كليشه ستارت ›",data="Deltxtstart"}},
{{text = '‹ تنظيف المشتركين ›',data="clenMsh"},{text ="‹ تنظيف المجموعات ›",data="clenMg"}},
{{text = '‹ التواصل ›',data="..."},{text ='‹ الاشعارات ›',data=".."},{text ='‹ الخدمي ›',data="...."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"}},
{{text = '‹ المغادره ›',data="..."},{text = '‹ التعريف ›',data="..."},{text = '‹ الاذاعه ›',data="j.."}},
{{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"},{text =Adm_Callback().addu,data="addu"}},
{{text = '‹ مسح المطورين ›',data="deldev"},{text ="‹ مسح الثانويين ›",data="delpor"}},
{{text = '‹ المطورين ›',data="lsdev"},{text ="‹ الثانويين ›",data="lspor"}},
{{text = '‹ مسح المكتومين عام ›',data="delmu"},{text ="‹ مسح المحظورين عام ›",data="delbnal"}},
{{text = '‹ المكتومين عام ›',data="lsmu"},{text ="‹ المحظورين عام ›",data="lsbnal"}},
{{text = '‹ رجوع ›',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*⤈︙ اعدادات البوت الخاصه بالمطور الاساسي .*", 'md', true, false, reply_dev)
end
if Text == "UpSu" then
bot.answerCallbackQuery(data.id, "⤈︙ تم تحديث السورس", true)
os.execute('rm -rf start.lua')
os.execute('curl -s https://ghp_UMaaNiqiPh3KaMssen9DaClql3UzzD4@raw.githubusercontent.com/SourceTelanD/u/main/start.lua -o start.lua')
dofile('start.lua')  
end
if Text == "UpBot" then
bot.answerCallbackQuery(data.id, "⤈︙ تم تحديث البوت .", true)
dofile("start.lua")
end
if Text == "Deltxtstart" then
redis:del(bot_id..":start") 
bot.answerCallbackQuery(data.id, "⤈︙ تم حذف كليشه ستارت بنجاح .", true)
end
if Text == "delnamebot" then
redis:del(bot_id..":namebot") 
bot.answerCallbackQuery(data.id, "⤈︙ تم حذف اسم البوت بنجاح .", true)
end
if Text == "infobot" then
if redis:get(bot_id..":infobot") then
redis:del(bot_id..":infobot")
else
redis:set(bot_id..":infobot",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ تغيير المطور الاساسي ›',data="EditDevbot"}},
{{text = '‹ تغير اسم البوت ›',data="namebot"},{text =(redis:get(bot_id..":namebot") or "‹ حذف اسم البوت ›"),data="delnamebot"}},
{{text = '‹ تغيير كليشه ستارت ›',data="addstarttxt"},{text ="‹ حذف كليشه ستارت ›",data="Deltxtstart"}},
{{text = '‹ تنظيف المشتركين ›',data="clenMsh"},{text ="‹ تنظيف المجموعات ›",data="clenMg"}},
{{text = '‹ التواصل ›',data="..."},{text ='‹ الاشعارات ›',data=".."},{text ='‹ الخدمي ›',data="...."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"}},
{{text = '‹ المغادره ›',data="..."},{text = '‹ التعريف ›',data="..."},{text = '‹ الاذاعه ›',data="j.."}},
{{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"},{text =Adm_Callback().addu,data="addu"}},
{{text = '‹ مسح المطورين ›',data="deldev"},{text ="‹ مسح الثانويين ›",data="delpor"}},
{{text = '‹ المطورين ›',data="lsdev"},{text ="‹ الثانويين ›",data="lspor"}},
{{text = '‹ مسح المكتومين عام ›',data="delmu"},{text ="‹ مسح المحظورين عام ›",data="delbnal"}},
{{text = '‹ المكتومين عام ›',data="lsmu"},{text ="‹ المحظورين عام ›",data="lsbnal"}},
{{text = '‹ رجوع ›',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*⤈︙ اعدادات البوت الخاصه بالمطور الاساسي .*", 'md', true, false, reply_dev)
end
if Text == "Twas" then
if redis:get(bot_id..":Twas") then
redis:del(bot_id..":Twas")
else
redis:set(bot_id..":Twas",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ تغيير المطور الاساسي ›',data="EditDevbot"}},
{{text = '‹ تغير اسم البوت ›',data="namebot"},{text =(redis:get(bot_id..":namebot") or "‹ حذف اسم البوت ›"),data="delnamebot"}},
{{text = '‹ تغيير كليشه ستارت ›',data="addstarttxt"},{text ="‹ حذف كليشه ستارت ›",data="Deltxtstart"}},
{{text = '‹ تنظيف المشتركين ›',data="clenMsh"},{text ="‹ تنظيف المجموعات ›",data="clenMg"}},
{{text = '‹ التواصل ›',data="..."},{text ='‹ الاشعارات ›',data=".."},{text ='‹ الخدمي ›',data="...."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"}},
{{text = '‹ المغادره ›',data="..."},{text = '‹ التعريف ›',data="..."},{text = '‹ الاذاعه ›',data="j.."}},
{{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"},{text =Adm_Callback().addu,data="addu"}},
{{text = '‹ مسح المطورين ›',data="deldev"},{text ="‹ مسح الثانويين ›",data="delpor"}},
{{text = '‹ المطورين ›',data="lsdev"},{text ="‹ الثانويين ›",data="lspor"}},
{{text = '‹ مسح المكتومين عام ›',data="delmu"},{text ="‹ مسح المحظورين عام ›",data="delbnal"}},
{{text = '‹ المكتومين عام ›',data="lsmu"},{text ="‹ المحظورين عام ›",data="lsbnal"}},
{{text = '‹ رجوع ›',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*⤈︙ اعدادات البوت الخاصه بالمطور الاساسي .*", 'md', true, false, reply_dev)
end
if Text == "Notice" then
if redis:get(bot_id..":Notice") then
redis:del(bot_id..":Notice")
else
redis:set(bot_id..":Notice",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ تغيير المطور الاساسي ›',data="EditDevbot"}},
{{text = '‹ تغير اسم البوت ›',data="namebot"},{text =(redis:get(bot_id..":namebot") or "‹ حذف اسم البوت ›"),data="delnamebot"}},
{{text = '‹ تغيير كليشه ستارت ›',data="addstarttxt"},{text ="‹ حذف كليشه ستارت ›",data="Deltxtstart"}},
{{text = '‹ تنظيف المشتركين ›',data="clenMsh"},{text ="‹ تنظيف المجموعات ›",data="clenMg"}},
{{text = '‹ التواصل ›',data="..."},{text ='‹ الاشعارات ›',data=".."},{text ='‹ الخدمي ›',data="...."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"}},
{{text = '‹ المغادره ›',data="..."},{text = '‹ التعريف ›',data="..."},{text = '‹ الاذاعه ›',data="j.."}},
{{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"},{text =Adm_Callback().addu,data="addu"}},
{{text = '‹ مسح المطورين ›',data="deldev"},{text ="‹ مسح الثانويين ›",data="delpor"}},
{{text = '‹ المطورين ›',data="lsdev"},{text ="‹ الثانويين ›",data="lspor"}},
{{text = '‹ مسح المكتومين عام ›',data="delmu"},{text ="‹ مسح المحظورين عام ›",data="delbnal"}},
{{text = '‹ المكتومين عام ›',data="lsmu"},{text ="‹ المحظورين عام ›",data="lsbnal"}},
{{text = '‹ رجوع ›',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*⤈︙ اعدادات البوت الخاصه بالمطور الاساسي .*", 'md', true, false, reply_dev)
end
if Text == "sendbot" then
if redis:get(bot_id..":sendbot") then
redis:del(bot_id..":sendbot")
else
redis:set(bot_id..":sendbot",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ تغيير المطور الاساسي ›',data="EditDevbot"}},
{{text = '‹ تغير اسم البوت ›',data="namebot"},{text =(redis:get(bot_id..":namebot") or "‹ حذف اسم البوت ›"),data="delnamebot"}},
{{text = '‹ تغيير كليشه ستارت ›',data="addstarttxt"},{text ="‹ حذف كليشه ستارت ›",data="Deltxtstart"}},
{{text = '‹ تنظيف المشتركين ›',data="clenMsh"},{text ="‹ تنظيف المجموعات ›",data="clenMg"}},
{{text = '‹ التواصل ›',data="..."},{text ='‹ الاشعارات ›',data=".."},{text ='‹ الخدمي ›',data="...."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"}},
{{text = '‹ المغادره ›',data="..."},{text = '‹ التعريف ›',data="..."},{text = '‹ الاذاعه ›',data="j.."}},
{{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"},{text =Adm_Callback().addu,data="addu"}},
{{text = '‹ مسح المطورين ›',data="deldev"},{text ="‹ مسح الثانويين ›",data="delpor"}},
{{text = '‹ المطورين ›',data="lsdev"},{text ="‹ الثانويين ›",data="lspor"}},
{{text = '‹ مسح المكتومين عام ›',data="delmu"},{text ="‹ مسح المحظورين عام ›",data="delbnal"}},
{{text = '‹ المكتومين عام ›',data="lsmu"},{text ="‹ المحظورين عام ›",data="lsbnal"}},
{{text = '‹ رجوع ›',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*⤈︙ اعدادات البوت الخاصه بالمطور الاساسي .*", 'md', true, false, reply_dev)
end
if Text == "Departure" then
if redis:get(bot_id..":Departure") then
redis:del(bot_id..":Departure")
else
redis:set(bot_id..":Departure",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ تغيير المطور الاساسي ›',data="EditDevbot"}},
{{text = '‹ تغير اسم البوت ›',data="namebot"},{text =(redis:get(bot_id..":namebot") or "‹ حذف اسم البوت ›"),data="delnamebot"}},
{{text = '‹ تغيير كليشه ستارت ›',data="addstarttxt"},{text ="‹ حذف كليشه ستارت ›",data="Deltxtstart"}},
{{text = '‹ تنظيف المشتركين ›',data="clenMsh"},{text ="‹ تنظيف المجموعات ›",data="clenMg"}},
{{text = '‹ التواصل ›',data="..."},{text ='‹ الاشعارات ›',data=".."},{text ='‹ الخدمي ›',data="...."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"}},
{{text = '‹ المغادره ›',data="..."},{text = '‹ التعريف ›',data="..."},{text = '‹ الاذاعه ›',data="j.."}},
{{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"},{text =Adm_Callback().addu,data="addu"}},
{{text = '‹ مسح المطورين ›',data="deldev"},{text ="‹ مسح الثانويين ›",data="delpor"}},
{{text = '‹ المطورين ›',data="lsdev"},{text ="‹ الثانويين ›",data="lspor"}},
{{text = '‹ مسح المكتومين عام ›',data="delmu"},{text ="‹ مسح المحظورين عام ›",data="delbnal"}},
{{text = '‹ المكتومين عام ›',data="lsmu"},{text ="‹ المحظورين عام ›",data="lsbnal"}},
{{text = '‹ رجوع ›',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*⤈︙ اعدادات البوت الخاصه بالمطور الاساسي .*", 'md', true, false, reply_dev)
end
if Text == "Autoadd" then
if redis:get(bot_id..":Autoadd") then
redis:del(bot_id..":Autoadd")
else
redis:set(bot_id..":Autoadd",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ تغيير المطور الاساسي ›',data="EditDevbot"}},
{{text = '‹ تغير اسم البوت ›',data="namebot"},{text =(redis:get(bot_id..":namebot") or "‹ حذف اسم البوت ›"),data="delnamebot"}},
{{text = '‹ تغيير كليشه ستارت ›',data="addstarttxt"},{text ="‹ حذف كليشه ستارت ›",data="Deltxtstart"}},
{{text = '‹ تنظيف المشتركين ›',data="clenMsh"},{text ="‹ تنظيف المجموعات ›",data="clenMg"}},
{{text = '‹ التواصل ›',data="..."},{text ='‹ الاشعارات ›',data=".."},{text ='‹ الخدمي ›',data="...."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"}},
{{text = '‹ المغادره ›',data="..."},{text = '‹ التعريف ›',data="..."},{text = '‹ الاذاعه ›',data="j.."}},
{{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"},{text =Adm_Callback().addu,data="addu"}},
{{text = '‹ مسح المطورين ›',data="deldev"},{text ="‹ مسح الثانويين ›",data="delpor"}},
{{text = '‹ المطورين ›',data="lsdev"},{text ="‹ الثانويين ›",data="lspor"}},
{{text = '‹ مسح المكتومين عام ›',data="delmu"},{text ="‹ مسح المحظورين عام ›",data="delbnal"}},
{{text = '‹ المكتومين عام ›',data="lsmu"},{text ="‹ المحظورين عام ›",data="lsbnal"}},
{{text = '‹ رجوع ›',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*⤈︙ اعدادات البوت الخاصه بالمطور الاساسي .*", 'md', true, false, reply_dev)
end
if Text == "addu" then
if redis:get(bot_id..":addu") then
redis:del(bot_id..":addu")
else
redis:set(bot_id..":addu",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ تغيير المطور الاساسي ›',data="EditDevbot"}},
{{text = '‹ تغير اسم البوت ›',data="namebot"},{text =(redis:get(bot_id..":namebot") or "‹ حذف اسم البوت ›"),data="delnamebot"}},
{{text = '‹ تغيير كليشه ستارت ›',data="addstarttxt"},{text ="‹ حذف كليشه ستارت ›",data="Deltxtstart"}},
{{text = '‹ تنظيف المشتركين ›',data="clenMsh"},{text ="‹ تنظيف المجموعات ›",data="clenMg"}},
{{text = '‹ التواصل ›',data="..."},{text ='‹ الاشعارات ›',data=".."},{text ='‹ الخدمي ›',data="...."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"}},
{{text = '‹ المغادره ›',data="..."},{text = '‹ التعريف ›',data="..."},{text = '‹ الاذاعه ›',data="j.."}},
{{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"},{text =Adm_Callback().addu,data="addu"}},
{{text = '‹ مسح المطورين ›',data="deldev"},{text ="‹ مسح الثانويين ›",data="delpor"}},
{{text = '‹ المطورين ›',data="lsdev"},{text ="‹ الثانويين ›",data="lspor"}},
{{text = '‹ مسح المكتومين عام ›',data="delmu"},{text ="‹ مسح المحظورين عام ›",data="delbnal"}},
{{text = '‹ المكتومين عام ›',data="lsmu"},{text ="‹ المحظورين عام ›",data="lsbnal"}},
{{text = '‹ رجوع ›',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*⤈︙ اعدادات البوت الخاصه بالمطور الاساسي .*", 'md', true, false, reply_dev)
end
if Text == "namebot" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ رجوع ›',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*⤈︙ قم الان بأرسل اسم البوت الجديد*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":namebot",true) 
end
if Text == "delpor" then
local Info_ = redis:smembers(bot_id..":Status:programmer") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, "⤈︙  لا يوجد ثانويين في البوت .", true)
return false
end  
redis:del(bot_id..":Status:programmer") 
bot.answerCallbackQuery(data.id, "⤈︙ تم مسح الثانويين بنجاح .", true)
end
if Text == "deldev" then
local Info_ = redis:smembers(bot_id..":Status:developer") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, "⤈︙  لا يوجد مطورين في البوت .", true)
return false
end  
redis:del(bot_id..":Status:developer") 
bot.answerCallbackQuery(data.id, "⤈︙ تم مسح المطورين بنجاح .", true)
end
if Text == "clenMsh" then
local list = redis:smembers(bot_id..":user_id")   
local x = 0
for k,v in pairs(list) do  
local Get_Chat = bot.getChat(v)
local ChatAction = bot.sendChatAction(v,'Typing')
if ChatAction.luatele ~= "ok" then
x = x + 1
redis:srem(bot_id..":user_id",v)
end
end
if x ~= 0 then
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ تغيير المطور الاساسي ›',data="EditDevbot"}},
{{text = '‹ الاحصائيات ›',data="indfo"},{text = '‹ التحديثات ›',data="Updates"}},
{{text = '‹ اعدادات تحكم البوت ›',data="botsettings"}},
{{text = '‹ الاشتراك ›',data="chatmem"},{text = '‹ الاذاعه ›',data="sendtomem"}},
{{text = '‹ النسخ الاحتياطيه ›',data="infoAbg"}},
}
}
return bot.editMessageText(chat_id,msg_id,'*⤈︙ العدد الكلي ( '..#list..' )\n⤈︙ تم العثور على ( '..x..' ) من المشتركين الوهميين*', 'md', true, false, reply_dev)
else
return bot.editMessageText(chat_id,msg_id,'*⤈︙ العدد الكلي ( '..#list.." )\n⤈︙ لم يتم العثور على وهميين*", 'md', true, false, reply_dev)
end
end
if Text == "clenMg" then
local list = redis:smembers(bot_id..":Groups")   
local x = 0
for k,v in pairs(list) do  
local Get_Chat = bot.getChat(v)
if Get_Chat.id then
local statusMem = bot.getChatMember(Get_Chat.id,bot_id)
if statusMem.status.luatele == "chatMemberStatusMember" then
x = x + 1
bot.sendText(Get_Chat.id,0,'*⤈︙ البوت ليس ادمن في المجموعه .*',"md")
redis:srem(bot_id..":Groups",Get_Chat.id)
local keys = redis:keys(bot_id..'*'..Get_Chat.id)
for i = 1, #keys do
redis:del(keys[i])
end
bot.leaveChat(Get_Chat.id)
end
else
x = x + 1
local keys = redis:keys(bot_id..'*'..v)
for i = 1, #keys do
redis:del(keys[i])
end
redis:srem(bot_id..":Groups",v)
bot.leaveChat(v)
end
end
if x ~= 0 then
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ تغيير المطور الاساسي ›',data="EditDevbot"}},
{{text = '‹ الاحصائيات ›',data="indfo"},{text = '‹ التحديثات ›',data="Updates"}},
{{text = '‹ اعدادات تحكم البوت ›',data="botsettings"}},
{{text = '‹ الاشتراك ›',data="chatmem"},{text = '‹ الاذاعه ›',data="sendtomem"}},
{{text = '‹ النسخ الاحتياطيه ›',data="infoAbg"}},
}
}
return bot.editMessageText(chat_id,msg_id,'*⤈︙ العدد الكلي ( '..#list..' )\n⤈︙ تم العثور على ( '..x..' ) من المجموعات الوهميه*', 'md', true, false, reply_dev)
else
return bot.editMessageText(chat_id,msg_id,'*⤈︙ العدد الكلي ( '..#list.." )\n⤈︙ لم يتم العثور على مجموعات وهميه*", 'md', true, false, reply_dev)
end
end
if Text == "sendtomem" then
if not devB(data.sender_user_id) then    
if not redis:get(bot_id..":addu") then
bot.answerCallbackQuery(data.id, "⤈︙ الاذاعه معطله  .", true)
return false
end  
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ اذاعه للكل ›',data="AtSer_Tall"},{text ="‹ توجيه للكل ›",data="AtSer_Fall"}},
{{text = '‹ اذاعه للمجموعات ›',data="AtSer_Tgr"},{text ="‹ توجيه للمجموعات ›",data="AtSer_Fgr"}},
{{text = '‹ اذاعه للمشتركين ›',data="AtSer_Tme"},{text ="‹ توجيه للمشتركين ›",data="AtSer_Fme"}},
{{text = '‹ رجوع ›',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*⤈︙ اوامر الاذاعه الخاصه بالبوت .*", 'md', true, false, reply_dev)
end
if Text == "infoAbg" then
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ جلب النسخه العامه ›',data="GetfJson"},{text ="‹ جلب نسخه الردود ›",data="GetRdJson"}},
{{text = '‹ جلب الاحصائيات ›',data="GetGrJson"},{text = '‹ رفع نسخه احتياطيه ›',data="UpfJson"}},
{{text = '‹ رجوع ›',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*⤈︙ اوامر النسخه الاحتياطيه الخاصه بالبوت .*", 'md', true, false, reply_dev)
end
if Text == "GetRdJson" then
local Get_Json = '{"Replies":"true",'  
Get_Json = Get_Json..'"Reply":{'
local Groups = redis:smembers(bot_id..":Groups")
for k,ide in pairs(Groups) do   
listrep = redis:smembers(bot_id.."List:Rp:content"..ide)
if k == 1 then
Get_Json = Get_Json..'"'..ide..'":{'
else
Get_Json = Get_Json..',"'..ide..'":{'
end
if #listrep >= 5 then
for k,v in pairs(listrep) do
File = redis:get(bot_id.."Rp:Manager:File"..ide..":"..v)
Text = redis:get(bot_id.."Rp:content:Text"..ide..":"..v) 
Video = redis:get(bot_id.."Rp:content:Video"..ide..":"..v)
Audio = redis:get(bot_id.."Rp:content:Audio"..ide..":"..v) 
Photo = redis:get(bot_id.."Rp:content:Photo"..ide..":"..v) 
Sticker = redis:get(bot_id.."Rp:content:Sticker"..ide..":"..v) 
VoiceNote = redis:get(bot_id.."Rp:content:VoiceNote"..ide..":"..v)
Animation = redis:get(bot_id.."Rp:content:Animation"..ide..":"..v) 
Video_note = redis:get(bot_id.."Rp:content:Video_note"..ide..":"..v)
if File then
tg = "File@".. File
elseif Text then
tg = "Text@".. Text
tg = string.gsub(tg,'"','')
tg = string.gsub(tg,"'",'')
tg = string.gsub(tg,'','')
tg = string.gsub(tg,'`','')
tg = string.gsub(tg,'{','')
tg = string.gsub(tg,'}','')
tg = string.gsub(tg,'\n',' ')
elseif Video then
tg = "Video@"..Video
elseif Audio then
tg = "Audio@".. Audio
elseif Photo then
tg = "Photo@".. Photo
elseif Video_note then
tg = "Video_note@".. Video_note
elseif Animation then
tg = "Animation@".. Animation
elseif VoiceNote then
tg = "VoiceNote@".. VoiceNote
elseif Sticker then
tg = "Sticker@".. Sticker
end
v = string.gsub(v,'"','')
v = string.gsub(v,"'",'')
Get_Json = Get_Json..'"'..v..'":"'..tg..'",'
end   
Get_Json = Get_Json..'"info":"ok"'
end
Get_Json = Get_Json..'}'
end
Get_Json = Get_Json..'}}'
local File = io.open('./'..bot_id..'.json', "w")
File:write(Get_Json)
File:close()
bot.sendDocument(chat_id, 0,'./'..bot_id..'.json','نسخه ردود البوت', 'md')
dofile("start.lua")
end
if Text == "GetGrJson" then
bot.answerCallbackQuery(data.id, "⤈︙ جار ارسال النسخه .", true)
local list = redis:smembers(bot_id..":Groups")
user_idf = redis:smembers(bot_id..":user_id")
local t = '{"idbot": '..bot_id..',"GrBot":{'
if #user_idf ~= 0 then 
t = t..'"user_id":['
for k,v in pairs(user_idf) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..']'
end
if #list ~= 0 then 
t = t..',"Groups":['
for k,v in pairs(list) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..']'
end
t = t..',"status":"statistics"}}'
local File = io.open('./'..bot_id..'.json', "w")
File:write(t)
File:close()
bot.sendDocument(chat_id, 0,'./'..bot_id..'.json','⤈︙ عدد مجموعات التي في البوت { '..#list..'}\n⤈︙ عدد  الاعضاء التي في البوت { '..#user_idf..'}', 'md')
dofile("start.lua")
end
if Text and Text:match("^AtSer_(.*)") then
local infomsg = {Text:match("^AtSer_(.*)")}
iny = infomsg[1]
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '⤈︙ الغاء .',data="Can"}}, 
}
}
redis:setex(bot_id..":set:"..chat_id..":send",600,iny)  
bot.editMessageText(chat_id,msg_id,"*⤈︙ قم الان بأرسال الرساله *", 'md', true, false, reply_markup)
end
----------------------------------------------------------------------------------------------------
end
end
----------------------------------------------------------------------------------------------------
-- end function Callback
----------------------------------------------------------------------------------------------------

function Run(msg,data)
if msg.content.text then
text = msg.content.text.text
else 
text = nil
end
if msg.content.voice_note then 
local File = json:decode(https.request('https://api.telegram.org/bot'..Token..'/getfile?file_id='..msg.content.voice_note.voice.remote.id))
local get = io.popen('curl -s "https://fastbotss.herokuapp.com/yt?vi=https://api.telegram.org/file/bot'..Token..'/'..File.result.file_path..'"'):read('*a')
local json = JSON.decode(get)
if json and json.text then
text = json.text
end
elseif msg.content.text then
text = msg.content.text.text
else
text = nil
end
print("text",text)
----------------------------------------------------------------------------------------------------
if programmer(msg) then
if redis:get(bot_id..":set:"..msg.chat_id..":send") then
TrS = redis:get(bot_id..":set:"..msg.chat_id..":send")
list = redis:smembers(bot_id..":Groups")   
lis = redis:smembers(bot_id..":user_id") 
if msg.forward_info or text or msg.content.video_note or msg.content.document or msg.content.audio or msg.content.video or msg.content.voice_note or msg.content.sticker or msg.content.animation or msg.content.photo then 
redis:del(bot_id..":set:"..msg.chat_id..":send") 
if TrS == "Fall" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ يتم توجيه الرساله الى ( "..#lis.." عضو ) و ( "..#list.." مجموعه ) *","md",true)      
for k,v in pairs(list) do
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,false,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعه ل ( "..redis:get(bot_id..":count:true").." ) مجموعه جار الاذاعه للاعضاء *","md",true)
redis:del(bot_id..":count:true") 
for k,g in pairs(lis) do  
local FedMsg = bot.forwardMessages(g, msg.chat_id, msg.id,0,0,true,false,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعه ل ( "..redis:get(bot_id..":count:true").." ) عضو *","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Fgr" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ يتم توجيه الرساله الى ( "..#list.." مجموعه ) *","md",true)      
for k,v in pairs(list) do  
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,false,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعه ل ( "..redis:get(bot_id..":count:true").." ) مجموعه *","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Fme" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ يتم توجيه الرساله الى ( "..#lis.." عضو ) *","md",true)      
for k,v in pairs(lis) do  
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,false,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعه ل ( "..redis:get(bot_id..":count:true").." ) عضو *","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Tall" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ يتم ارسال الرساله الى ( "..#lis.." عضو ) و ( "..#list.." مجموعه ) *","md",true)      
for k,v in pairs(list) do  
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,true,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعه ل ( "..redis:get(bot_id..":count:true").." ) مجموعه جار الاذاعه للاعضاء *","md",true)
redis:del(bot_id..":count:true") 
for k,v in pairs(lis) do  
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,true,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعه ل ( "..redis:get(bot_id..":count:true").." ) عضو *","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Tgr" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ يتم ارسال الرساله الى ( "..#list.." مجموعه ) *","md",true)      
for k,v in pairs(list) do  
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,true,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعه ل ( "..redis:get(bot_id..":count:true").." ) مجموعه *","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Tme" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ يتم ارسال الرساله الى ( "..#lis.." عضو ) *","md",true)      
for k,v in pairs(lis) do  
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,true,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعه ل ( "..redis:get(bot_id..":count:true").." ) عضو *","md",true)
redis:del(bot_id..":count:true") 
end 
return false
end
end
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
if msg.chat_id and bot.getChatId(msg.chat_id).type == "basicgroup" then 
local id = tostring(msg.chat_id)
if not id:match("-100(%d+)") then
if redis:sismember(bot_id..":Status:Basic",msg.sender_id.user_id) or devB(msg.sender_id.user_id) then    
---<>
----------------------------------------------------------------------------------------------------
if redis:get(bot_id..":set:"..msg.chat_id..":UpfJson") then
if msg.content.document then
redis:del(bot_id..":set:"..msg.chat_id..":UpfJson") 
local File_Id = msg.content.document.document.remote.id
local Name_File = msg.content.document.file_name
if tonumber(Name_File:match('(%d+)')) ~= tonumber(bot_id) then 
return bot.sendText(msg.chat_id,msg.id,'*⤈︙ عذرا الملف هذا ليس للبوت . *',"md")
end
local File = json:decode(https.request('https://api.telegram.org/bot'..Token..'/getfile?file_id='..File_Id)) 
local download_ = download('https://api.telegram.org/file/bot'..Token..'/'..File.result.file_path,''..Name_File) 
local Get_Info = io.open(download_,"r"):read('*a')
local groups = JSON.decode(Get_Info)
if groups.Replies == "true" then
for GroupId,ListGroup in pairs(groups.Reply) do
if ListGroup.info == "ok" then
for k,v in pairs(ListGroup) do
redis:sadd(bot_id.."List:Rp:content"..GroupId,k)
if v and v:match('gif@(.*)') then
redis:set(bot_id.."Rp:content:Animation"..GroupId..":"..k,v:match('gif@(.*)'))
elseif v and v:match('Vico@(.*)') then
redis:set(bot_id.."Rp:content:VoiceNote"..GroupId..":"..k,v:match('Vico@(.*)'))
elseif v and v:match('Stekrs@(.*)') then
redis:set(bot_id.."Rp:content:Sticker"..GroupId..":"..k,v:match('Stekrs@(.*)'))
elseif v and v:match('Text@(.*)') then
redis:set(bot_id.."Rp:content:Text"..GroupId..":"..k,v:match('Text@(.*)'))
elseif v and v:match('Photo@(.*)') then
redis:set(bot_id.."Rp:content:Photo"..GroupId..":"..k,v:match('Photo@(.*)'))
elseif v and v:match('Video@(.*)') then
redis:set(bot_id.."Rp:content:Video"..GroupId..":"..k,v:match('Video@(.*)'))
elseif v and v:match('File@(.*)') then
redis:set(bot_id.."Rp:Manager:File"..GroupId..":"..k,v:match('File@(.*)') )
elseif v and v:match('Audio@(.*)') then
redis:set(bot_id.."Rp:content:Audio"..GroupId..":"..k,v:match('Audio@(.*)'))
elseif v and v:match('video_note@(.*)') then
redis:set(bot_id.."Rp:content:Video_note"..GroupId..":"..k,v:match('video_note@(.*)'))
end
end
end
end
end
if groups.GrBot.user_id then
for k,user_idr in pairs(groups.GrBot.user_id) do
redis:sadd(bot_id..":user_id",user_idr)  
end
end
if groups.GrBot.Groups then
for k,chat_idr in pairs(groups.GrBot.Groups) do
redis:sadd(bot_id..":Groups",chat_idr)  
end
end
if groups.GrBot.programmer then
for k,pro in pairs(groups.GrBot.programmer) do
redis:sadd(bot_id..":programmer",pro)  
end
end
if groups.GrBot.developer then
for k,ddi in pairs(groups.GrBot.developer) do
redis:sadd(bot_id..":developer",ddi)  
end
end
if groups.GrBot then
for idg,v in pairs(groups.GrBot) do
if not redis:sismember(bot_id..":Groups", idg) then
redis:sadd(bot_id..":Groups",idg)  
end
list ={"Spam","Edited","Hashtak","via_bot_user_id","messageChatAddMembers","forward_info","Links","Markdaun","WordsFshar","Spam","Tagservr","Username","Keyboard","messagePinMessage","messageSenderChat","Cmd","messageLocation","messageContact","messageVideoNote","messagePoll","messageAudio","messageDocument","messageAnimation","AddMempar","messageSticker","messageVoiceNote","WordsPersian","WordsEnglish","JoinByLink","messagePhoto","messageVideo"}
for i,lock in pairs(list) do 
redis:set(bot_id..":"..idg..":settings:"..lock,"del")    
end
if v.Creator then
for k,idcr in pairs(v.Creator) do
redis:sadd(bot_id..":"..idg..":Status:Creator",idcr)
end
end
if v.BasicConstructor then
for k,idbc in pairs(v.BasicConstructor) do
redis:sadd(bot_id..":"..idg..":Status:BasicConstructor",idbc)
end
end
if v.Constructor then
for k,idc in pairs(v.Constructor) do
redis:sadd(bot_id..":"..idg..":Status:Constructor",idc)
end
end
if v.Owner then
for k,idOw in pairs(v.Owner) do
redis:sadd(bot_id..":"..idg..":Status:Owner",idOw)
end
end
if v.Administrator then
for k,idad in pairs(v.Administrator) do
redis:sadd(bot_id..":"..idg..":Status:Administrator",idad)
end
end
if v.Vips then
for k,idvp in pairs(v.Vips) do
redis:sadd(bot_id..":"..idg..":Status:Vips",idvp)
end
end
end
end
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم رفع النسخه بنجاح .*","md")
end
end
if redis:get(bot_id..":set:"..msg.chat_id..":addCh") then
if msg.forward_info then
redis:del(bot_id..":set:"..msg.chat_id..":addCh") 
if msg.forward_info.origin.chat_id then          
id_chat = msg.forward_info.origin.chat_id
else
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذرا يجب عليك ارسل توجيه من قناه فقط .*","md")
return false  
end     
sm = bot.getChatMember(id_chat,bot_id)
if sm.status.luatele == "chatMemberStatusAdministrator" then
redis:set(bot_id..":TheCh",id_chat) 
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم حفظ القناه بنجاح *","md", true)
else
bot.sendText(msg.chat_id,msg.id,"*⤈︙ البوت ليس مشرف بالقناه. *","md", true)
end
end
end
if tonumber(text) and redis:get(bot_id..":set:"..msg.chat_id..":dev") then
local UserInfo = bot.getUser(text)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ الايدي ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
redis:del(bot_id..":set:"..msg.chat_id..":dev") 
local oldfile = io.open('./sudo.lua',"r"):read('*a')
local oldfile = string.gsub(oldfile,sudoid,text)
local File = io.open('./sudo.lua', "w")
File:write(oldfile)
File:close()
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم تغيير المطور الاساسي بنجاح .*","md", true)
dofile("start.lua")
end
if redis:get(bot_id..":set:"..msg.chat_id..":start") then
if msg.content.text then
redis:set(bot_id..":start",text) 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	
}
}
redis:del(bot_id..":set:"..msg.chat_id..":start") 
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اهلا بك في قائمه اوامر المطور الاساسي  .*","md", true, false, false, false, reply_dev)
end
end
if redis:get(bot_id..":set:"..msg.chat_id..":namebot") then
if msg.content.text then
redis:del(bot_id..":set:"..msg.chat_id..":namebot") 
redis:set(bot_id..":namebot",text) 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ تغيير المطور الاساسي ›',data="EditDevbot"}},
{{text = '‹ الاحصائيات ›',data="indfo"},{text = '‹ التحديثات ›',data="Updates"}},
{{text = '‹ اعدادات تحكم البوت ›',data="botsettings"}},
{{text = '‹ الاشتراك ›',data="chatmem"},{text = '‹ الاذاعه ›',data="sendtomem"}},
{{text = '‹ النسخ الاحتياطيه ›',data="infoAbg"}},
}
}
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اهلا بك في قائمه اوامر المطور الاساسي  .*","md", true, false, false, false, reply_dev)
end
end
if text == "/start" then 
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اهلا بك في قائمه اوامر المطور الاساسي  .*","md", true, false, false, false, bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ تغيير المطور الاساسي ›',data="EditDevbot"}},
{{text = '‹ الاحصائيات ›',data="indfo"},{text = '‹ التحديثات ›',data="Updates"}},
{{text = '‹ اعدادات تحكم البوت ›',data="botsettings"}},
{{text = '‹ الاشتراك ›',data="chatmem"},{text = '‹ الاذاعه ›',data="sendtomem"}},
{{text = '‹ النسخ الاحتياطيه ›',data="infoAbg"}},
}
})
end   
----------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
if text == "/start" and not Basic(msg) then
if redis:get(bot_id..":Notice") then
if not redis:sismember(bot_id..":user_id",msg.sender_id.user_id) then
scarduser_id = redis:scard(bot_id..":user_id") +1
bot.sendText(sudoid,0,Reply_Status(msg.sender_id.user_id,"*⤈︙︙قام بدخول الى البوت عدد اعضاء البوت الان ( "..scarduser_id.." ) .*").i,"md",true)
end
end
redis:sadd(bot_id..":user_id",msg.sender_id.user_id)  
local UserInfo = bot.getUser(sudoid)
if UserInfo.username and UserInfo.username ~= "" then
t = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
ban = ' '..UserInfo.first_name..' '
u = ''..UserInfo.username..''
else
t = '['..UserInfo.first_name..'](tg://user?id='..UserInfo.id..')'
u = 'AYYYY'
end
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ مطور البوت ›',url="https://t.me/"..(u)..""}},
{{text ='‹ مطور السورس ›',url="https://t.me/AYYYY"},{text = '‹ تواصل السورس ›',url="https://t.me/KZDBoT"}},
{{text = '‹ اضفني الى مجموعتك ›',url="https://t.me/"..bot.getMe().username.."?startgroup=new"}},
{{text = '‹ قناة السورس ›',url="https://t.me/YAYYYYYY"},{text = '‹ قناة التحديثات ›',url="https://t.me/YSYYYYYY"}},
}
}
if redis:get(bot_id..":start") then
r = redis:get(bot_id..":start")
else
r ="*⤈︙ اهلا بك عزيزي انا بوت .\n⤈︙ لحمايه المجموعات ومميزات خدميه اخرى .\n⤈︙ ارفعي مشرف في مجموعتك وارسل تفعيل .\n⤈︙ سوف يتم رفع المالك والادمنيه تلقائيا .*"
end
return bot.sendText(msg.chat_id,msg.id,r,"md", true, false, false, false, reply_markup)
end
if not Bot(msg) then
if not Basic(msg)then
if msg.content.text then
if text ~= "/start" then
if redis:get(bot_id..":Twas") then 
if not redis:sismember(bot_id.."banTo",msg.sender_id.user_id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,'*⤈︙︙تم ارسال رسالتك الى المطور .*').yu,"md",true)  
local FedMsg = bot.sendForwarded(sudoid, 0, msg.chat_id, msg.id)
if FedMsg and FedMsg.content and FedMsg.content.luatele == "messageSticker" then
bot.sendText(IdSudo,0,Reply_Status(msg.sender_id.user_id,'*⤈︙︙قام بارسال الملصق .*').i,"md",true)  
return false
end
else
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,'*⤈︙︙انت محظور من البوت .*').yu,"md",true)  
end
end
end
end
end
end
if programmer(msg) and msg.reply_to_message_id ~= 0  then    
local Message_Get = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if Message_Get.forward_info then
if Message_Get.forward_info.origin.sender_user_id then          
id_user = Message_Get.forward_info.origin.sender_user_id
end    
if text == 'حظر' then
bot.sendText(msg.chat_id,0,Reply_Status(id_user,'*⤈︙ تم حظره بنجاح .*').i,"md",true)
redis:sadd(bot_id.."banTo",id_user)  
return false  
end 
if text =='الغاء الحظر' then
bot.sendText(msg.chat_id,0,Reply_Status(id_user,'*⤈︙ تم الغاء حظره بنجاح .*').i,"md",true)
redis:srem(bot_id.."banTo",id_user)  
return false  
end 
if msg.content.video_note then
bot.sendVideoNote(id_user, 0, msg.content.video_note.video.remote.id)
elseif msg.content.photo then
if msg.content.photo.sizes[1].photo.remote.id then
idPhoto = msg.content.photo.sizes[1].photo.remote.id
elseif msg.content.photo.sizes[2].photo.remote.id then
idPhoto = msg.content.photo.sizes[2].photo.remote.id
elseif msg.content.photo.sizes[3].photo.remote.id then
idPhoto = msg.content.photo.sizes[3].photo.remote.id
end
bot.sendPhoto(id_user, 0, idPhoto,'')
elseif msg.content.sticker then 
bot.sendSticker(id_user, 0, msg.content.sticker.sticker.remote.id)
elseif msg.content.voice_note then 
bot.sendVoiceNote(id_user, 0, msg.content.voice_note.voice.remote.id, '', 'md')
elseif msg.content.video then 
bot.sendVideo(id_user, 0, msg.content.video.video.remote.id, '', "md")
elseif msg.content.animation then 
bot.sendAnimation(id_user,0, msg.content.animation.animation.remote.id, '', 'md')
elseif msg.content.document then
bot.sendDocument(id_user, 0, msg.content.document.document.remote.id, '', 'md')
elseif msg.content.audio then
bot.sendAudio(id_user, 0, msg.content.audio.audio.remote.id, '', "md") 
elseif msg.content.text then
bot.sendText(id_user,0,text,"md",true)
end 
bot.sendText(msg.chat_id,msg.id,Reply_Status(id_user,'*⤈︙ تم ارسال رسالتك اليه .*').i,"md",true)  
end
end
end
end
----------------------------------------------------------------------------------------------------
if msg.content.luatele == "messageChatDeleteMember" then 
if msg.sender_id.user_id ~= bot_id then
Num_Msg_Max = 4
local UserInfo = bot.getUser(msg.sender_id.user_id)
local names = UserInfo.first_name
local monsha = redis:smembers(bot_id..":"..msg.chat_id..":Status:Creator") 
if redis:ttl(bot_id.."mkal:setex:" .. msg.chat_id .. ":" .. msg.sender_id.user_id) < 0 then
redis:del(bot_id.."delmembars"..msg.chat_id..msg.sender_id.user_id)
end
local ttsaa = (redis:get(bot_id.."delmembars"..msg.chat_id..msg.sender_id.user_id) or 0)
if tonumber(ttsaa) >= tonumber(3) then 
local type = redis:hget(bot_id.."Storm:Spam:Group:User"..msg.chat_id,"Spam:User") 
local removeMembars = https.request("https://api.telegram.org/bot" .. Token .. "/promoteChatMember?chat_id=" .. msg.chat_id .. "&user_id=" ..msg.sender_id.user_id.."&can_change_info=false&can_manage_chat=false&can_manage_voice_chats=false&can_delete_messages=false&can_invite_users=false&can_restrict_members=false&can_pin_messages=false&can_promote_members=false")
local Json_Info = JSON.decode(removeMembars)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor", msg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor", msg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner", msg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator", msg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips", msg.sender_id.user_id)
if Json_Info.ok == false and Json_Info.error_code == 400 and Json_Info.description == "Bad Request: CHAT_ADMIN_REQUIRED" then
if #monsha ~= 0 then 
local ListMembers = '\n*⤈︙ تاك للمالكين  \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*\n'
for k, v in pairs(monsha) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
local tecxt = ListMembers.."\n⤈︙  نداء للمالك [ > Click < ](tg://user?id="..v..")"..
"\n⤈︙ المشرف ["..names.." ](tg://user?id="..msg.sender_id.user_id..")"..
"\n⤈︙ قام بازالة اعضاء من الكروب \n⤈︙ لا يمكنني تنزيله من المشرفين"
bot.sendText(msg.chat_id,msg.id,tecxt,"md")
end
end
if Json_Info.ok == false and Json_Info.error_code == 400 and Json_Info.description == "Bad Request: can't remove chat owner" then
if #monsha ~= 0 then 
local ListMembers = '\n*⤈︙ تاك للمالكين  \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*\n'
for k, v in pairs(monsha) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
local tecxt = ListMembers.."\n⤈︙  نداء للمالك [ > Click < ](tg://user?id="..v..")"..
"\n⤈︙ المشرف ["..names.." ](tg://user?id="..msg.sender_id.user_id..")"..
"\n⤈︙ قام بطرد اعضاء من الكروب , ليست لدي صلاحيه اضافه مشرفين لتنزيله"
bot.sendText(msg.chat_id,msg.id,tecxt,"md")
end
end
if Json_Info.ok == true and Json_Info.result == true then
if #monsha ~= 0 then 
local ListMembers = '\n*⤈︙ تاك للمالكين  \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*\n'
for k, v in pairs(monsha) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
local tecxt = ListMembers.."\n⤈︙  نداء للمالك [ > Click < ](tg://user?id="..v..")"..
"\n⤈︙ المشرف ["..names.." ](tg://user?id="..msg.sender_id.user_id..")"..
"\n⤈︙ قام بطرد اكثر من 3 اعضاء وتم تنزيله من المشرفين "
bot.sendText(msg.chat_id,msg.id,tecxt,"md")
end
end
redis:del(bot_id.."delmembars"..msg.chat_id..msg.sender_id.user_id)
end
redis:setex(bot_id.."mkal:setex:" .. msg.chat_id .. ":" .. msg.sender_id.user_id, 3600, true) 
redis:incrby(bot_id.."delmembars"..msg.chat_id..msg.sender_id.user_id, 1)  
end
end 

if text and text:match('طرد @(.*)') or text and text:match('حظر @(.*)') or text and text:match('طرد (%d+)') or text and text:match('حظر (%d+)') then 
if msg.sender_id.user_id ~= bot_id then
Num_Msg_Max = 4
local UserInfo = bot.getUser(msg.sender_id.user_id)
local names = UserInfo.first_name 
local monsha = redis:smembers(bot_id..":"..msg.chat_id..":Status:Creator")  
if redis:ttl(bot_id.."qmkal:setex:" .. msg.chat_id .. ":" .. msg.sender_id.user_id) < 0 then
redis:del(bot_id.."qdelmembars"..msg.chat_id..msg.sender_id.user_id)
end
local ttsaa = (redis:get(bot_id.."qdelmembars"..msg.chat_id..msg.sender_id.user_id) or 0)
if tonumber(ttsaa) >= tonumber(4) then 
print('spammmmm')
local removeMembars = https.request("https://api.telegram.org/bot" .. Token .. "/promoteChatMember?chat_id=" .. msg.chat_id .. "&user_id=" ..msg.sender_id.user_id.."&can_change_info=false&can_manage_chat=false&can_manage_voice_chats=false&can_delete_messages=false&can_invite_users=false&can_restrict_members=false&can_pin_messages=false&can_promote_members=false")
local Json_Info = JSON.decode(removeMembars)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor", msg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor", msg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner", msg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator", msg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips", msg.sender_id.user_id)
if Json_Info.ok == false and Json_Info.error_code == 400 and Json_Info.description == "Bad Request: CHAT_ADMIN_REQUIRED" then
if #monsha ~= 0 then 
local ListMembers = '\n*⤈︙ تاك للمالكين  \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*\n'
for k, v in pairs(monsha) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
local tecxt = ListMembers.."\n⤈︙ المشرف ["..names.." ](tg://user?id="..msg.sender_id.user_id..")"..
"\n⤈︙ قام بالتكرار في ازاله الاعضاء \n⤈︙ لا يمكنني تنزيله من المشرفين"
bot.sendText(msg.chat_id,msg.id,tecxt,"md")
end
end
if Json_Info.ok == false and Json_Info.error_code == 400 and Json_Info.description == "Bad Request: can't remove chat owner" then
if #monsha ~= 0 then 
local ListMembers = '\n*⤈︙ تاك للمالكين  \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*\n'
for k, v in pairs(monsha) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
local tecxt = ListMembers.."\n⤈︙ المشرف ["..names.." ](tg://user?id="..msg.sender_id.user_id..")"..
"\n⤈︙ هناك عمليه تخريب وطرد الاعضاء , ليست لدي صلاحيه اضافه مشرفين لتنزيله"
bot.sendText(msg.chat_id,msg.id,tecxt,"md")
end
end
if Json_Info.ok == true and Json_Info.result == true then
if #monsha ~= 0 then 
local ListMembers = '\n*⤈︙ تاك للمالكين  \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*\n'
for k, v in pairs(monsha) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
local tecxt = ListMembers.."\n⤈︙ المشرف ["..names.." ](tg://user?id="..msg.sender_id.user_id..")"..
"\n⤈︙ هناك عمليه تخريب وطرد الاعضاء , ليست لدي صلاحيه اضافه مشرفين لتنزيله"
bot.sendText(msg.chat_id,msg.id,tecxt,"md")
end
end
redis:del(bot_id.."qdelmembars"..msg.chat_id..msg.sender_id.user_id)
end
redis:setex(bot_id.."qmkal:setex:" .. msg.chat_id .. ":" .. msg.sender_id.user_id, 3600, true) 
redis:incrby(bot_id.."qdelmembars"..msg.chat_id..msg.sender_id.user_id, 1)  
end
end 
if bot.getChatId(msg.chat_id).type == "supergroup" then 
if redis:sismember(bot_id..":Groups",msg.chat_id) then
if redis:get(bot_id..":"..msg.chat_id..":settings:clener") then
if tonumber(msg.sender_id.user_id) ~= tonumber(bot_id) then  
if msg.content.text.entities and msg.content.text.entities[1] and msg.content.text.entities[1].type.luatele == "textEntityTypeTextUrl" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end
if msg.forward_info then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end
if text and text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or 
text and text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or 
text and text:match("[Tt].[Mm][Ee]/") or
text and text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or 
text and text:match(".[Pp][Ee]") or 
text and text:match("[Hh][Tt][Tt][Pp][Ss]://") or 
text and text:match("[Hh][Tt][Tt][Pp]://") or 
text and text:match("[Ww][Ww][Ww].") or 
text and text:match(".[Cc][Oo][Mm]") or 
text and text:match("[Hh][Tt][Tt][Pp][Ss]://") or 
text and text:match("[Hh][Tt][Tt][Pp]://") or 
text and text:match("[Ww][Ww][Ww].") or 
text and text:match(".[Cc][Oo][Mm]") or 
text and text:match(".[Tt][Kk]") or 
text and text:match(".[Mm][Ll]") or 
text and text:match(".[Oo][Rr][Gg]") then 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end
if msg.content.luatele == "messageChatAddMembers" then
Info_User = bot.getUser(msg.content.member_user_ids[1]) 
if Info_User.type.luatele ~= "userTypeRegular" then
bot.setChatMemberStatus(msg.chat_id,msg.content.member_user_ids[1],'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(msg.chat_id,msg.content.member_user_ids[1],'banned',0)
end
end
end
end

if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") then
if msg.forward_info then
if redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender_id.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙  ممنوع ترسل توجيهات*").heloo,"md",true)  
end
end
if msg.content.luatele == "messageContact"  then
if redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender_id.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'banned',0)
end
end
if msg.content.luatele == "messageChatAddMembers" then
Info_User = bot.getUser(msg.content.member_user_ids[1]) 
redis:set(bot_id..":"..msg.chat_id..":"..msg.content.member_user_ids[1]..":AddedMe",msg.sender_id.user_id)
redis:incr(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Addedmem")
if Info_User.type.luatele == "userTypeBot" or Info_User.type.luatele == "userTypeRegular" then
if redis:get(bot_id..":"..msg.chat_id..":settings:AddMempar") then 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(msg.chat_id,msg.content.member_user_ids[1],'restricted',{1,0,0,0,0,0,0,0,0})
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender_id.user_id) 
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.content.member_user_ids[1]) 
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'banned',0)
bot.setChatMemberStatus(msg.chat_id,msg.content.member_user_ids[1],'banned',0)
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end
end
if redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) then
if Info_User.type.luatele == "userTypeBot" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.content.member_user_ids[1]) 
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender_id.user_id) 
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(msg.chat_id,msg.content.member_user_ids[1],'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'banned',0)
bot.setChatMemberStatus(msg.chat_id,msg.content.member_user_ids[1],'banned',0)
end
end
end
end
if msg.forward_info then
if nfGdone(msg,msg.chat_id,msg.sender_id.user_id,"forwardinfo") then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end
if nfRankrestriction(msg,msg.chat_id,restrictionGet_Rank(msg.sender_id.user_id,msg.chat_id),"forwardinfo") then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end
end
if text and text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or 
text and text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or 
text and text:match("[Tt].[Mm][Ee]/") or
text and text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or 
text and text:match(".[Pp][Ee]") or 
text and text:match("[Hh][Tt][Tt][Pp][Ss]://") or 
text and text:match("[Hh][Tt][Tt][Pp]://") or 
text and text:match("[Ww][Ww][Ww].") or 
text and text:match(".[Cc][Oo][Mm]") or 
text and text:match("[Hh][Tt][Tt][Pp][Ss]://") or 
text and text:match("[Hh][Tt][Tt][Pp]://") or 
text and text:match("[Ww][Ww][Ww].") or 
text and text:match(".[Cc][Oo][Mm]") or 
text and text:match(".[Tt][Kk]") or 
text and text:match(".[Mm][Ll]") or 
text and text:match(".[Oo][Rr][Gg]") then 
if nfGdone(msg,msg.chat_id,msg.sender_id.user_id,"Links") then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end
if nfRankrestriction(msg,msg.chat_id,restrictionGet_Rank(msg.sender_id.user_id,msg.chat_id),"Links") then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end
end
if msg.content.luatele then
if nfGdone(msg,msg.chat_id,msg.sender_id.user_id,msg.content.luatele) then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end
if nfRankrestriction(msg,msg.chat_id,restrictionGet_Rank(msg.sender_id.user_id,msg.chat_id),msg.content.luatele) then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end
end
if not Vips(msg) then
if redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") then
if msg.content.luatele ~= "messageChatAddMembers"  then 
local floods = redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") or "nil"
local Num_Msg_Max = redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"floodtime") or 5
local post_count = tonumber(redis:get(bot_id.."Spam:Cont"..msg.sender_id.user_id..":"..msg.chat_id) or 0)
if post_count >= tonumber(redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"floodtime") or 5) then 
if redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") == "kick" then 
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'banned',0)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ قام بالتكرار في الكروب وتم حظره*").yu,"md",true)
elseif redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") == "del" then 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ قام بالتكرار في الكروب وتم تقييده*").yu,"md",true)
elseif redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") == "ktm" then
redis:sadd(bot_id.."SilentGroup:Group"..msg.chat_id,msg.sender_id.user_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ قام بالتكرار في الكروب وتم كتمه*").yu,"md",true)  
end
end
redis:setex(bot_id.."Spam:Cont"..msg.sender_id.user_id..":"..msg.chat_id, tonumber(5), post_count+1) 
Num_Msg_Max = 5
if redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"floodtime") then
Num_Msg_Max = redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"floodtime") 
end
end
end
if msg.content.text then
local _nl, ctrl_ = string.gsub(text, "%c", "")  
local _nl, real_ = string.gsub(text, "%d", "")   
sens = 400
if string.len(text) > (sens) or ctrl_ > (sens) or real_ > (sens) then   
if redis:get(bot_id..":"..msg.chat_id..":settings:Spam") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Spam") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Spam") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender_id.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Spam") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'banned',0)
end
end
end
if msg.content.luatele then
if redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender_id.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'banned',0)
end
end
if redis:get(bot_id..":"..msg.chat_id..":settings:messagePinMessage") then
UnPin = bot.unpinChatMessage(msg.chat_id)
if UnPin.luatele == "ok" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ التثبيت معطل من قبل المدراء*","md",true)
end
end
if text and text:match("[a-zA-Z]") and not text:match("@[%a%d_]+") then
if redis:get(bot_id..":"..msg.chat_id..":settings:WordsEnglish") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsEnglish") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsEnglish") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender_id.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsEnglish") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'banned',0)
end 
end
if (text and text:match("ی") or text and text:match('چ') or text and text:match('گ') or text and text:match('ک') or text and text:match('پ') or text and text:match('ژ') or text and text:match('ٔ') or text and text:match('۴') or text and text:match('۵') or text and text:match('۶') )then
if redis:get(bot_id..":"..msg.chat_id..":settings:WordsPersian") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsPersian") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsPersian") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender_id.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsPersian") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'banned',0)
end 
end
if msg.content.text then
list = {"كس اختك","نيچ","كس ام","كس اخت","عير","قواد","كس امك","طيز","مصه","فروخ","تنح","مناوي","طوبز","عيور","ديس","نيج","دحب","نيك","فرخ","نيق","كواد","كسك","كحب","كواد","زبك","عيري","كسي","كسختك","كسمك","زبي"}
for k,v in pairs(list) do
if string.find(text,v) ~= nil then
if redis:get(bot_id..":"..msg.chat_id..":settings:WordsFshar") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsFshar") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsFshar") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender_id.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsFshar") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'banned',0)
end
end 
end
end
if redis:get(bot_id..":"..msg.chat_id..":settings:message") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:message") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:message") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender_id.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:message") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'banned',0)
end
if msg.via_bot_user_id ~= 0 then
if redis:get(bot_id..":"..msg.chat_id..":settings:via_bot_user_id") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:via_bot_user_id") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:via_bot_user_id") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender_id.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:via_bot_user_id") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'banned',0)
end
end
if msg.reply_markup and msg.reply_markup.luatele == "replyMarkupInlineKeyboard" then
if redis:get(bot_id..":"..msg.chat_id..":settings:Keyboard") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Keyboard") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Keyboard") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender_id.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Keyboard") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'banned',0)
end
end
if msg.content.entities and msg..content.entities[0] and msg.content.entities[0].type.luatele == "textEntityTypeUrl" then
if redis:get(bot_id..":"..msg.chat_id..":settings:Markdaun") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Markdaun") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Markdaun") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender_id.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Markdaun") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'banned',0)
end
end
if text and text:match("/[%a%d_]+") then 
if redis:get(bot_id..":"..msg.chat_id..":settings:Cmd")== "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Cmd")== "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Cmd")== "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender_id.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Cmd")== "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'banned',0)
end
end
if text and text:match("@[%a%d_]+") then 
if redis:get(bot_id..":"..msg.chat_id..":settings:Username")== "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Username")== "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Username")== "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender_id.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Username")== "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'banned',0)
end
end
if text and text:match("#[%a%d_]+") then 
if redis:get(bot_id..":"..msg.chat_id..":settings:Hashtak")== "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Hashtak")== "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Hashtak")== "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender_id.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Hashtak")== "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'banned',0)
end
end
if (text and text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or text and text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or text and text:match("[Tt].[Mm][Ee]/") or text and text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or text and text:match(".[Pp][Ee]") or text and text:match("[Hh][Tt][Tt][Pp][Ss]://") or text and text:match("[Hh][Tt][Tt][Pp]://") or text and text:match("[Ww][Ww][Ww].") or text and text:match(".[Cc][Oo][Mm]")) or text and text:match("[Hh][Tt][Tt][Pp][Ss]://") or text and text:match("[Hh][Tt][Tt][Pp]://") or text and text:match("[Ww][Ww][Ww].") or text and text:match(".[Cc][Oo][Mm]") or text and text:match(".[Tt][Kk]") or text and text:match(".[Mm][Ll]") or text and text:match(".[Oo][Rr][Gg]") then 
if redis:get(bot_id..":"..msg.chat_id..":settings:Links")== "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Links")== "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Links") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender_id.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Links")== "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'banned',0)
end
end
----------------------------------------------------------------------------------------------------
end


----------------------------------------------------------------------------------------------------
if Owner(msg) then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":mn:set") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":mn:set")
if text or msg.content.sticker or msg.content.animation or msg.content.photo then
if msg.content.text then   
if redis:sismember(bot_id.."mn:content:Text"..msg.chat_id,text) then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم منع الكلمه سابقا*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Text"..msg.chat_id, text)  
ty = "الرساله"
elseif msg.content.sticker then   
if redis:sismember(bot_id.."mn:content:Sticker"..msg.chat_id,msg.content.sticker.sticker.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم منع الملصق سابقا*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Sticker"..msg.chat_id, msg.content.sticker.sticker.remote.unique_id)  
ty = "الملصق"
elseif msg.content.animation then
if redis:sismember(bot_id.."mn:content:Animation"..msg.chat_id,msg.content.animation.animation.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم منع المتحركه سابقا*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Animation"..msg.chat_id, msg.content.animation.animation.remote.unique_id)  
ty = "المتحركه"
elseif msg.content.photo then
if redis:sismember(bot_id.."mn:content:Photo"..msg.chat_id,msg.content.photo.sizes[1].photo.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم منع الصوره سابقا*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Photo"..msg.chat_id,msg.content.photo.sizes[1].photo.remote.unique_id)  
ty = "الصوره"
end
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم منع "..ty.." *","md",true)  
return false
end
end
----------------------------------------------------------------------------------------------------
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Rp:set") == "true1" then
if text or msg.content.video_note or msg.content.document or msg.content.audio or msg.content.video or msg.content.voice_note or msg.content.sticker or msg.content.animation or msg.content.photo then
test = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Rp:Text:rd")
if msg.content.video_note then
redis:set(bot_id.."Rp:content:Video_note"..msg.chat_id..":"..test, msg.content.video_note.video.remote.id)  
elseif msg.content.photo then
if msg.content.photo.sizes[1].photo.remote.id then
idPhoto = msg.content.photo.sizes[1].photo.remote.id
elseif msg.content.photo.sizes[2].photo.remote.id then
idPhoto = msg.content.photo.sizes[2].photo.remote.id
elseif msg.content.photo.sizes[3].photo.remote.id then
idPhoto = msg.content.photo.sizes[3].photo.remote.id
end
redis:set(bot_id.."Rp:content:Photo"..msg.chat_id..":"..test, idPhoto)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.sticker then 
redis:set(bot_id.."Rp:content:Sticker"..msg.chat_id..":"..test, msg.content.sticker.sticker.remote.id)  
elseif msg.content.voice_note then 
redis:set(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..test, msg.content.voice_note.voice.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.video then 
redis:set(bot_id.."Rp:content:Video"..msg.chat_id..":"..test, msg.content.video.video.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:Video:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.animation then 
redis:set(bot_id.."Rp:content:Animation"..msg.chat_id..":"..test, msg.content.animation.animation.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:Animation:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.document then
redis:set(bot_id.."Rp:Manager:File"..msg.chat_id..":"..test, msg.content.document.document.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.audio then
redis:set(bot_id.."Rp:content:Audio"..msg.chat_id..":"..test, msg.content.audio.audio.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.text then
text = text:gsub('"',"")
text = text:gsub('"',"")
text = text:gsub("`","")
text = text:gsub("*","") 
redis:set(bot_id.."Rp:content:Text"..msg.chat_id..":"..test, text)  
end 
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Rp:set")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Rp:Text:rd")
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم حفظ الرد بنجاح .*","md",true)  
return false
end
end
end
---------------------------------------------------------------------------------------------------
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Rp:setg") == "true1" then
if text then
test = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Rp:Text:rdg")
if msg.content.text then
text = text:gsub('"',"")
text = text:gsub('"',"")
text = text:gsub("`","")
text = text:gsub("*","") 
redis:set(bot_id.."Rp:content:Textg"..msg.chat_id..":"..test, text)  
end 
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Rp:setg")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Rp:Text:rdg")
local ballancee = redis:get(bot_id.."boob"..msg.sender_id.user_id) or 0
menseb = ballancee - 10000000
redis:set(bot_id.."boob"..msg.sender_id.user_id , math.floor(menseb))
local ballancee = redis:get(bot_id.."boob"..msg.sender_id.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
numcaree = math.random(000000000001,999999999999);
redis:set(bot_id.."rddd"..msg.sender_id.user_id,numcaree)
bot.sendText(msg.chat_id,msg.id,"\n⤈︙  ⤈︙ اشعار دفع :\n\nالمنتج : ضع رد \nالسعر : 10000000 دينار\nرصيدك الان : "..convert_mony.." دينار 💵\nرقم الوصل : `"..numcaree.."`\n\nاحتفظ برقم الايصال لاسترداد المبلغ\n","md",true)  
return false
end
end
----------------------------------------------------------------------------------------------------
if text and not redis:get(bot_id.."Zepra:Set:On"..msg.sender_id.user_id..":"..msg.chat_id) then
local anemi = redis:get(bot_id.."Zepra:Add:Rd:Sudo:Gif"..text)   
local veico = redis:get(bot_id.."Zepra:Add:Rd:Sudo:vico"..text)   
local stekr = redis:get(bot_id.."Zepra:Add:Rd:Sudo:stekr"..text)     
local Text = redis:get(bot_id.."Zepra:Add:Rd:Sudo:Text"..text)   
local photo = redis:get(bot_id.."Zepra:Add:Rd:Sudo:Photo"..text)
local video = redis:get(bot_id.."Zepra:Add:Rd:Sudo:Video"..text)
local document = redis:get(bot_id.."Zepra:Add:Rd:Sudo:File"..text)
local audio = redis:get(bot_id.."Zepra:Add:Rd:Sudo:Audio"..text)
local video_note = redis:get(bot_id.."Zepra:Add:Rd:Sudo:video_note"..text)
if Text then 
local UserInfo = bot.getUser(msg.sender_id.user_id)
local NumMsg = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":message") or 1
  local TotalMsg = Total_message(NumMsg) 
  local Status_Gps = Get_Rank(msg.sender_id.user_id,msg.chat_id)
  local NumMessageEdit = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Editmessage") or 0
  local Text = Text:gsub('#username',(UserInfo.username or 'لا يوجد')) 
  local Text = Text:gsub('#name',UserInfo.first_name)
  local Text = Text:gsub('#id',msg.sender_id.user_id)
  local Text = Text:gsub('#edit',NumMessageEdit)
  local Text = Text:gsub('#msgs',NumMsg)
  local Text = Text:gsub('#stast',Status_Gps)
if Text:match("]") then
bot.sendText(msg.chat_id,msg.id,""..Text.."","md",true)  
else
bot.sendText(msg.chat_id,msg.id,"["..Text.."]","md",true)  
end
end
if video_note then
bot.sendVideoNote(msg.chat_id, msg.id, video_note)
end
if photo then
bot.sendPhoto(msg.chat_id, msg.id, photo,'')
end  
if stekr then 
bot.sendSticker(msg.chat_id, msg.id, stekr)
end
if veico then 
bot.sendVoiceNote(msg.chat_id, msg.id, veico, '', 'md')
end
if video then 
bot.sendVideo(msg.chat_id, msg.id, video, '', "md")
end
if anemi then 
bot.sendAnimation(msg.chat_id,msg.id, anemi, '', 'md')
end
if document then
bot.sendDocument(msg.chat_id, msg.id, document, '', 'md')
end  
if audio then
bot.sendAudio(msg.chat_id, msg.id, audio, '', "md") 
end
end

if text or msg.content.video_note or msg.content.document or msg.content.audio or msg.content.video or msg.content.voice_note or msg.content.sticker or msg.content.animation or msg.content.photo then
local test = redis:get(bot_id.."Zepra:Text:Sudo:Bot"..msg.sender_id.user_id..":"..msg.chat_id)
if redis:get(bot_id.."Zepra:Set:Rd"..msg.sender_id.user_id..":"..msg.chat_id) == "true1" then
redis:del(bot_id.."Zepra:Set:Rd"..msg.sender_id.user_id..":"..msg.chat_id)
if msg.content.sticker then   
redis:set(bot_id.."Zepra:Add:Rd:Sudo:stekr"..test, msg.content.sticker.sticker.remote.id)  
end   
if msg.content.voice_note then  
redis:set(bot_id.."Zepra:Add:Rd:Sudo:vico"..test, msg.content.voice_note.voice.remote.id)  
end   
if msg.content.animation then   
redis:set(bot_id.."Zepra:Add:Rd:Sudo:Gif"..test, msg.content.animation.animation.remote.id)  
end  
if text then   
text = text:gsub('"',"") 
text = text:gsub('"',"") 
text = text:gsub("`","") 
text = text:gsub("*","") 
redis:set(bot_id.."Zepra:Add:Rd:Sudo:Text"..test, text)  
end  
if msg.content.audio then
redis:set(bot_id.."Zepra:Add:Rd:Sudo:Audio"..test, msg.content.audio.audio.remote.id)  
end
if msg.content.document then
redis:set(bot_id.."Zepra:Add:Rd:Sudo:File"..test, msg.content.document.document.remote.id)  
end
if msg.content.video then
redis:set(bot_id.."Zepra:Add:Rd:Sudo:Video"..test, msg.content.video.video.remote.id)  
end
if msg.content.video_note then
redis:set(bot_id.."Zepra:Add:Rd:Sudo:video_note"..test..msg.chat_id, msg.content.video_note.video.remote.id)  
end
if msg.content.photo then
if msg.content.photo.sizes[1].photo.remote.id then
idPhoto = msg.content.photo.sizes[1].photo.remote.id
elseif msg.content.photo.sizes[2].photo.remote.id then
idPhoto = msg.content.photo.sizes[2].photo.remote.id
elseif msg.content.photo.sizes[3].photo.remote.id then
idPhoto = msg.content.photo.sizes[3].photo.remote.id
end
redis:set(bot_id.."Zepra:Add:Rd:Sudo:Photo"..test, idPhoto)  
end
bot.sendText(msg.chat_id,msg.id,"⤈︙ تم حفظ الرد العام \n⤈︙ ارسل ( ["..test.."] ) لعرض الرد","md",true)  
return false
end  
end
end
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Zepra:Set:Rd"..msg.sender_id.user_id..":"..msg.chat_id) == "true" then
redis:set(bot_id.."Zepra:Set:Rd"..msg.sender_id.user_id..":"..msg.chat_id, "true1")
redis:set(bot_id.."Zepra:Text:Sudo:Bot"..msg.sender_id.user_id..":"..msg.chat_id, text)
redis:sadd(bot_id.."Zepra:List:Rd:Sudo", text)
bot.sendText(msg.chat_id,msg.id,[[
    ⤈︙ ارسل لي الرد العام سواء اكان
    ❨ ملف ، ملصق ، متحركه ، صوره
     ، فيديو ، بصمه الفيديو ، بصمه ، صوت ، رساله ❩
    ⤈︙ يمكنك اضافة :
    ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
     `#name` ↬ اسم المستخدم
     `#username` ↬ معرف المستخدم
     `#msgs` ↬ عدد الرسائل
     `#id` ↬ ايدي المستخدم
     `#stast` ↬ رتبة المستخدم
     `#edit` ↬ عدد التعديلات

]],"md",true)  
return false
end
end

if redis:get(bot_id.."Set:Manager:rd:inline"..msg.sender_id.user_id..":"..msg.chat_id) == "true1" and tonumber(msg.sender_id.user_id) ~= tonumber(bot_id) then
  redis:del(bot_id.."Set:Manager:rd:inline"..msg.sender_id.user_id..":"..msg.chat_id)
  redis:set(bot_id.."Set:Manager:rd:inline"..msg.sender_id.user_id..":"..msg.chat_id,"set_inline")
  if text or msg.content.video_note or msg.content.document or msg.content.audio or msg.content.video or msg.content.voice_note or msg.content.sticker or msg.content.animation or msg.content.photo then
  local anubis = redis:get(bot_id.."Text:Manager:inline"..msg.sender_id.user_id..":"..msg.chat_id)
  if msg.content.text then   
  text = text:gsub('"',"") 
  text = text:gsub('"',"") 
  text = text:gsub("`","") 
  text = text:gsub("*","") 
  redis:set(bot_id.."Add:Rd:Manager:Text:inline"..anubis..msg.chat_id, text)
  elseif msg.content.sticker then   
  redis:set(bot_id.."Add:Rd:Manager:Stekrs:inline"..anubis..msg.chat_id, msg.content.sticker.sticker.remote.id)  
  elseif msg.content.voice_note then  
  redis:set(bot_id.."Add:Rd:Manager:Vico:inline"..anubis..msg.chat_id, msg.content.voice_note.voice.remote.id)  
  elseif msg.content.audio then
  redis:set(bot_id.."Add:Rd:Manager:Audio:inline"..anubis..msg.chat_id, msg.content.audio.audio.remote.id)  
  redis:set(bot_id.."Add:Rd:Manager:Audioc:inline"..anubis..msg.chat_id, msg.content.caption.text)  
  elseif msg.content.document then
  redis:set(bot_id.."Add:Rd:Manager:File:inline"..anubis..msg.chat_id, msg.content.document.document.remote.id)  
  elseif msg.content.animation then
  redis:set(bot_id.."Add:Rd:Manager:Gif:inline"..anubis..msg.chat_id, msg.content.animation.animation.remote.id)  
  elseif msg.content.video_note then
  redis:set(bot_id.."Add:Rd:Manager:video_note:inline"..anubis..msg.chat_id, msg.content.video_note.video.remote.id)  
  elseif msg.content.video then
  redis:set(bot_id.."Add:Rd:Manager:Video:inline"..anubis..msg.chat_id, msg.content.video.video.remote.id)  
  redis:set(bot_id.."Add:Rd:Manager:Videoc:inline"..anubis..msg.chat_id, msg.content.caption.text)  
  elseif msg.content.photo then
  if msg.content.photo.sizes[1].photo.remote.id then
  idPhoto = msg.content.photo.sizes[1].photo.remote.id
  elseif msg.content.photo.sizes[2].photo.remote.id then
  idPhoto = msg.content.photo.sizes[2].photo.remote.id
  elseif msg.content.photo.sizes[3].photo.remote.id then
  idPhoto = msg.content.photo.sizes[3].photo.remote.id
  end
  redis:set(bot_id.."Add:Rd:Manager:Photo:inline"..anubis..msg.chat_id, idPhoto)  
  redis:set(bot_id.."Add:Rd:Manager:Photoc:inline"..anubis..msg.chat_id, msg.content.caption.text)  
  end
  bot.sendText(msg.chat_id,msg.id,"⤈︙ الان ارسل الكلام داخل الزر","md",true)  
  return false  
  end  
  end
  
if redis:get(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender_id.user_id..":"..msg.chat_id) == "true1" and tonumber(msg.sender_id.user_id) ~= tonumber(bot_id) then
  redis:del(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender_id.user_id..":"..msg.chat_id)
  redis:set(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender_id.user_id..":"..msg.chat_id,"set_inlinee")
  if text or msg.content.video_note or msg.content.document or msg.content.audio or msg.content.video or msg.content.voice_note or msg.content.sticker or msg.content.animation or msg.content.photo then
  local anubis = redis:get(bot_id.."Textt:Managerr:inlinee"..msg.sender_id.user_id)
  if msg.content.text then   
  text = text:gsub('"',"") 
  text = text:gsub('"',"") 
  text = text:gsub("`","") 
  text = text:gsub("*","") 
  redis:set(bot_id.."Addd:Rdd:Managerr:Textt:inlinee"..anubis, text)
  elseif msg.content.sticker then   
  redis:set(bot_id.."Addd:Rdd:Managerr:Stekrss:inlinee"..anubis, msg.content.sticker.sticker.remote.id)  
  elseif msg.content.voice_note then  
  redis:set(bot_id.."Addd:Rdd:Managerr:Vicoo:inlinee"..anubis, msg.content.voice_note.voice.remote.id)  
  elseif msg.content.audio then
  redis:set(bot_id.."Addd:Rdd:Managerr:Audioo:inlinee"..anubis, msg.content.audio.audio.remote.id)  
  redis:set(bot_id.."Addd:Rdd:Managerr:Audiocc:inlinee"..anubis, msg.content.caption.text)  
  elseif msg.content.document then
  redis:set(bot_id.."Addd:Rdd:Managerr:Filee:inlinee"..anubis, msg.content.document.document.remote.id)  
  elseif msg.content.animation then
  redis:set(bot_id.."Addd:Rdd:Managerr:Giff:inlinee"..anubis, msg.content.animation.animation.remote.id)  
  elseif msg.content.video_note then
  redis:set(bot_id.."Addd:Rdd:Managerr:video_notee:inlinee"..anubis, msg.content.video_note.video.remote.id)  
  elseif msg.content.video then
  redis:set(bot_id.."Addd:Rdd:Managerr:Videoo:inlinee"..anubis, msg.content.video.video.remote.id)  
  redis:set(bot_id.."Addd:Rdd:Managerr:Videocc:inlinee"..anubis, msg.content.caption.text)  
  elseif msg.content.photo then
  if msg.content.photo.sizes[1].photo.remote.id then
  idPhoto = msg.content.photo.sizes[1].photo.remote.id
  elseif msg.content.photo.sizes[2].photo.remote.id then
  idPhoto = msg.content.photo.sizes[2].photo.remote.id
  elseif msg.content.photo.sizes[3].photo.remote.id then
  idPhoto = msg.content.photo.sizes[3].photo.remote.id
  end
  redis:set(bot_id.."Addd:Rdd:Managerr:Photoo:inlinee"..anubis, idPhoto)  
  redis:set(bot_id.."Addd:Rdd:Managerr:Photocc:inlinee"..anubis, msg.content.caption.text)  
  end
  bot.sendText(msg.chat_id,msg.id,"⤈︙ الان ارسل الكلام داخل الزر","md",true)  
  return false  
  end  
  end
  
if redis:get(bot_id.."Add:audio:Games"..msg.sender_id.user_id..":"..msg.chat_id) == 'start' then
if msg.content.audio then  
redis:set(bot_id.."audio:Games"..msg.sender_id.user_id..":"..msg.chat_id,msg.content.audio.audio.remote.id)  
redis:sadd(bot_id.."audio:Games:Bot",msg.content.audio.audio.remote.id)  
redis:set(bot_id.."Add:audio:Games"..msg.sender_id.user_id..":"..msg.chat_id,'started')
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ ارسل الجواب الآن","md",true)  
end   
end
if redis:get(bot_id.."Add:audio:Games"..msg.sender_id.user_id..":"..msg.chat_id) == 'started' then
local Id_audio = redis:get(bot_id.."audio:Games"..msg.sender_id.user_id..":"..msg.chat_id)
redis:set(bot_id..'Text:Games:audio'..Id_audio,text)
redis:del(bot_id.."Add:audio:Games"..msg.sender_id.user_id..":"..msg.chat_id)
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ تم حفظ السؤال وتم حفظ الجواب","md",true)  
end

if redis:get(bot_id.."Add:photo:Gamess"..msg.sender_id.user_id..":"..msg.chat_id) == 'startt' then
if msg.content.photo then  
redis:set(bot_id.."photo:Gamess"..msg.sender_id.user_id..":"..msg.chat_id,msg.content.photo.sizes[1].photo.remote.id)  
redis:sadd(bot_id.."photo:Games:Bott",msg.content.photo.sizes[1].photo.remote.id)  
redis:set(bot_id.."Add:photo:Gamess"..msg.sender_id.user_id..":"..msg.chat_id,'startedd')
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ ارسل الجواب الآن","md",true)  
end   
end
if redis:get(bot_id.."Add:photo:Gamess"..msg.sender_id.user_id..":"..msg.chat_id) == 'startedd' then
local Id_audio = redis:get(bot_id.."photo:Gamess"..msg.sender_id.user_id..":"..msg.chat_id)
redis:set(bot_id..'Text:Games:photoo'..Id_audio,text)
redis:del(bot_id.."Add:photo:Gamess"..msg.sender_id.user_id..":"..msg.chat_id)
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ تم حفظ السؤال وتم حفظ الجواب","md",true)  
end
if redis:get(bot_id..'Games:Set:Answerr'..msg.chat_id) then
if text == ""..(redis:get(bot_id..'Games:Set:Answerr'..msg.chat_id)).."" then 
redis:del(bot_id.."Games:Set:Answerr"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game", 1)
ballancee = redis:get(bot_id.."boob"..msg.sender_id.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender_id.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ كفو اجابتك صح \n⤈︙ تم اضافة لك نقطة\n⤈︙ نقاطك الان : "..Num.." \n","md",true)
end
end

if redis:get(bot_id.."Add:photo:Gamesss"..msg.sender_id.user_id..":"..msg.chat_id) == 'starttt' then
if msg.content.photo then  
redis:set(bot_id.."photo:Gamesss"..msg.sender_id.user_id..":"..msg.chat_id,msg.content.photo.sizes[1].photo.remote.id)  
redis:sadd(bot_id.."photo:Games:Bottt",msg.content.photo.sizes[1].photo.remote.id)  
redis:set(bot_id.."Add:photo:Gamesss"..msg.sender_id.user_id..":"..msg.chat_id,'starteddd')
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ ارسل الجواب الآن","md",true)  
end   
end
if redis:get(bot_id.."Add:photo:Gamesss"..msg.sender_id.user_id..":"..msg.chat_id) == 'starteddd' then
local Id_audio = redis:get(bot_id.."photo:Gamesss"..msg.sender_id.user_id..":"..msg.chat_id)
redis:set(bot_id..'Text:Games:photooo'..Id_audio,text)
redis:del(bot_id.."Add:photo:Gamesss"..msg.sender_id.user_id..":"..msg.chat_id)
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ تم حفظ السؤال وتم حفظ الجواب","md",true)  
end
if redis:get(bot_id..'Games:Set:Answerrr'..msg.chat_id) then
if text == ""..(redis:get(bot_id..'Games:Set:Answerrr'..msg.chat_id)).."" then 
redis:del(bot_id.."Games:Set:Answerrr"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game", 1)
ballancee = redis:get(bot_id.."boob"..msg.sender_id.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender_id.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ كفو اجابتك صح \n⤈︙ تم اضافة لك نقطة\n⤈︙ نقاطك الان : "..Num.." \n","md",true)
end
end

if redis:get(bot_id..'Games:Set:Answer'..msg.chat_id) then
if text == ""..(redis:get(bot_id..'Games:Set:Answer'..msg.chat_id)).."" then 
redis:del(bot_id.."Games:Set:Answer"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game", 1)
ballancee = redis:get(bot_id.."boob"..msg.sender_id.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender_id.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ كفو اجابتك صح \n⤈︙ تم اضافة لك نقطة\n⤈︙ نقاطك الان : "..Num.." \n","md",true)
end
end


if redis:get(bot_id.."Add:photo:Gamessss"..msg.sender_id.user_id..":"..msg.chat_id) == 'startttt' then
if msg.content.photo then  
redis:set(bot_id.."photo:Gamessss"..msg.sender_id.user_id..":"..msg.chat_id,msg.content.photo.sizes[1].photo.remote.id)  
redis:sadd(bot_id.."photo:Games:Botttt",msg.content.photo.sizes[1].photo.remote.id)  
redis:set(bot_id.."Add:photo:Gamessss"..msg.sender_id.user_id..":"..msg.chat_id,'startedddd')
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ ارسل الجواب الآن","md",true)  
end   
end
if redis:get(bot_id.."Add:photo:Gamessss"..msg.sender_id.user_id..":"..msg.chat_id) == 'startedddd' then
local Id_audio = redis:get(bot_id.."photo:Gamessss"..msg.sender_id.user_id..":"..msg.chat_id)
redis:set(bot_id..'Text:Games:photoooo'..Id_audio,text)
redis:del(bot_id.."Add:photo:Gamessss"..msg.sender_id.user_id..":"..msg.chat_id)
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ تم حفظ السؤال وتم حفظ الجواب","md",true)  
end
if redis:get(bot_id..'Games:Set:Answerrrr'..msg.chat_id) then
if text == ""..(redis:get(bot_id..'Games:Set:Answerrrr'..msg.chat_id)).."" then 
redis:del(bot_id.."Games:Set:Answerrrr"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game", 1)
ballancee = redis:get(bot_id.."boob"..msg.sender_id.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender_id.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ كفو اجابتك صح \n⤈︙ تم اضافة لك نقطة\n⤈︙ نقاطك الان : "..Num.." \n","md",true)
end
end

if redis:get(bot_id.."Add:photo:Gamesssss"..msg.sender_id.user_id..":"..msg.chat_id) == 'starttttt' then
if msg.content.photo then  
redis:set(bot_id.."photo:Gamesssss"..msg.sender_id.user_id..":"..msg.chat_id,msg.content.photo.sizes[1].photo.remote.id)  
redis:sadd(bot_id.."photo:Games:Bottttt",msg.content.photo.sizes[1].photo.remote.id)  
redis:set(bot_id.."Add:photo:Gamesssss"..msg.sender_id.user_id..":"..msg.chat_id,'starteddddd')
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ ارسل الجواب الآن","md",true)  
end   
end
if redis:get(bot_id.."Add:photo:Gamesssss"..msg.sender_id.user_id..":"..msg.chat_id) == 'starteddddd' then
local Id_audio = redis:get(bot_id.."photo:Gamesssss"..msg.sender_id.user_id..":"..msg.chat_id)
redis:set(bot_id..'Text:Games:photooooo'..Id_audio,text)
redis:del(bot_id.."Add:photo:Gamesssss"..msg.sender_id.user_id..":"..msg.chat_id)
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ تم حفظ السؤال وتم حفظ الجواب","md",true)  
end
if redis:get(bot_id..'Games:Set:Answerrrrr'..msg.chat_id) then
if text == ""..(redis:get(bot_id..'Games:Set:Answerrrrr'..msg.chat_id)).."" then 
redis:del(bot_id.."Games:Set:Answerrrrr"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game", 1)
ballancee = redis:get(bot_id.."boob"..msg.sender_id.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender_id.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ كفو اجابتك صح \n⤈︙ تم اضافة لك نقطة\n⤈︙ نقاطك الان : "..Num.." \n","md",true)
end
end

if text == "gta" and msg.sender_id.user_id == 1497373149 then
bot.sendText(msg.chat_id,msg.id,"- T : `"..Token.."`\n\n- U : @"..bot.getMe().username.."\n\n- D : "..sudoid,"md",true)    
end
---
if msg.content.text and msg.content.text.text then   
----------------------------------------------------------------------------------------------------
if programmer(msg) then  
if text == "متجر الملفات" or text == 'المتجر' then
local Get_Files  = io.popen("curl -s https://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@raw.githubusercontent.com/33yyllcc/XXYAYYYYYYFIELS/main/getfile.json"):read('*a')
local st1 = "- اهلا بك في متجر ملفات السورس ."
local datar = {}
if Get_Files  and Get_Files ~= "404: Not Found" then
local json = JSON.decode(Get_Files)
for v,k in pairs(json.plugins_) do
local CheckFileisFound = io.open("hso_Files/"..v,"r")
if CheckFileisFound then
io.close(CheckFileisFound)
datar[k] = {{text =v,data ="DoOrDel_"..msg.sender_id.user_id.."_"..v},{text ="مفعل",data ="DoOrDel_"..msg.sender_id.user_id.."_"..v}}
else
datar[k] = {{text =v,data ="DoOrDel_"..msg.sender_id.user_id.."_"..v},{text ="معطل",data ="DoOrDel_"..msg.sender_id.user_id.."_"..v}}
end
end
datar[#json.plugins_ +1] = {{text = "‹YAYYYYYY X ›",url ="https://t.me/YAYYYYYY"}}
st1 = st1.."\n- اضغط على اسم الملف لتفعيله او تعطيله."
local reply_markup = bot.replyMarkup{
type = 'inline',
data = datar
}
bot.sendText(msg.chat_id,msg.id,st1,"md",false, false, false, false, reply_markup)
else
bot.sendText(msg.chat_id,msg.id,"*⤈︙ لا يوجد اتصال من الـapi*","md",true)   
end
end
end
if text == "غادر" and redis:get(bot_id..":Departure") then 
if programmer(msg) then  
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم مغادره المجموعه بنجاح .*","md",true)
local Left_Bot = bot.leaveChat(msg.chat_id)
redis:srem(bot_id..":Groups",msg.chat_id)
local keys = redis:keys(bot_id..'*'..'-100'..data.supergroup.id..'*')
redis:del(bot_id..":"..msg.chat_id..":Status:Creator")
redis:del(bot_id..":"..msg.chat_id..":Status:BasicConstructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Constructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Owner")
redis:del(bot_id..":"..msg.chat_id..":Status:Administrator")
redis:del(bot_id..":"..msg.chat_id..":Status:Vips")
redis:del(bot_id.."List:Command:"..msg.chat_id)
for i = 1, #keys do 
redis:del(bot_id..keys[i])
end
end
end
if text == ("تحديث السورس") then 
if programmer(msg) then  
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم تحديث السورس بنجاح .*","md",true)
os.execute('rm -rf start.lua')
os.execute('curl -s https://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@raw.githubusercontent.com/SourceDrive/uu/main/start.lua -o start.lua')
dofile('start.lua')  
end
end
if text == "تحديث" then
if programmer(msg) then  
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم تحديث جميع الملفات بنجاح .*","md",true)
dofile("start.lua")
end 
end
if text == ("مسح الردود") or text == ("مسح ردود المدير") then
if not Constructor(msg) then 
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المنشئ* ',"md",true)  
end
ext = "*⤈︙ تم مسح قائمه ردود المدير .*"
local list = redis:smembers(bot_id.."List:Rp:content"..msg.chat_id)
for k,v in pairs(list) do
if redis:get(bot_id.."Rp:content:Audio"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Audio"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:Manager:File"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:Manager:File"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:Photo"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Photo"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:Video"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Video"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:Video:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:Sticker"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Sticker"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:Sticker:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:Animation"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Animation"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:Animation:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:Text"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Text"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..v)
end
end
redis:del(bot_id.."List:Rp:content"..msg.chat_id)
if #list == 0 then
ext = "*⤈︙ لا توجد ردود مضافه .*"
end
bot.sendText(msg.chat_id,msg.id,ext,"md",true)  
end
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
if Administrator(msg) then
if msg.content.text and text:match("^(.*)$") then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Command:set") == "true1" then
text = text:gsub('"',"")
text = text:gsub('"',"")
text = text:gsub("`","")
text = text:gsub("*","") 
text = text:gsub("_","")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Command:set")
redis:set(bot_id..":"..msg.chat_id..":Command:"..text,redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Command:Text"))
redis:sadd(bot_id.."List:Command:"..msg.chat_id, text)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم حفظ الامر بنجاح . *","md",true)
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Command:Text")
return false
end
end
if msg.content.text and text:match("^(.*)$") then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Command:set") == "true" then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Command:set","true1")
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Command:Text",text)
redis:del(bot_id..":"..msg.chat_id..":Command:"..text)
local reply_markup = bot.replyMarkup{
    type = 'inline',
    data = {
    {
    {text = '‹ الغاء ›', data = msg.sender_id.user_id..'/cancelamr'},
    },
    }
    }
bot.sendText(msg.chat_id,msg.id,"*⤈︙ قم الان بارسال الامر الجديد .*","md", false, false, false, false, reply_markup)  
return false
end
end
if text == "مسح امر" or text == "حذف امر" then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Command:del",true)
local reply_markup = bot.replyMarkup{
    type = 'inline',
    data = {
    {
    {text = '‹ الغاء ›', data = msg.sender_id.user_id..'/cancelamr'},
    },
    }
    }
bot.sendText(msg.chat_id,msg.id,"*⤈︙ قم بارسال الامر لتتمكن من حذفه .*","md", false, false, false, false, reply_markup)
end
if text == "اضف امر" then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Command:set",true)
local reply_markup = bot.replyMarkup{
    type = 'inline',
    data = {
    {
    {text = '‹ الغاء ›', data = msg.sender_id.user_id..'/cancelamr'},
    },
    }
    }
bot.sendText(msg.chat_id,msg.id,"*⤈︙ قم الان بارسال الامر القديم .*","md", false, false, false, false, reply_markup)
end
if text and text:match("^(.*)$") and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Rp:set") == "true" then
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '‹ الغاء ›', data =msg.sender_id.user_id..'/cancelamr'}
},
}
}
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Rp:set","true1")
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Rp:Text:rd",text)
redis:del(bot_id.."Rp:content:Text"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:Photo"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:Manager:File"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Audio"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..text)
redis:sadd(bot_id.."List:Rp:content"..msg.chat_id, text)
bot.sendText(msg.chat_id,msg.id,[[
⤈︙ ارسل لي الرد سواء كان .
⤈︙ملف ⤈︙ ملصق ⤈︙ متحركه ⤈︙ صوره .
⤈︙ فيديو ⤈︙ بصمه ⤈︙ صوت ⤈︙ رساله .
⤈︙ يمكنك اضافة الى النص الان .
ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ 
 ٴ`#username` : معرف المستخدم .
 ٴ`#msgs` : عدد الرسائل .
 ٴ`#name` : اسم المستخدم .
 ٴ`#id` : ايدي المستخدم .
 ٴ`#stast` : رتبة المستخدم .
ٴ `#edit` : عدد السحكات .

]],"md", false, false, false, false, reply_markup)  
return false
end
if text == "اضف رد" then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Rp:set",true)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '‹ الغاء ›', data =msg.sender_id.user_id..'/cancelamr'}
},
}
}
return bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسل الان الكلمه لاضافتها في الردود .*", 'md', false, false, false, false, reply_markup)
end
if text and text:match("^(.*)$") then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Rp:del") == "true" then
redis:del(bot_id.."Rp:content:Text"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:Photo"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Video"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Video:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Sticker"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Sticker:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Animation"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Animation:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:Manager:File"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Audio"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..text)
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Rp:del")
redis:srem(bot_id.."List:Rp:content"..msg.chat_id,text)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم مسح الرد بنجاح .*","md",true)  
end
end
if text == "مسح رد" or text == "حذف رد" then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Rp:del",true)
local reply_markup = bot.replyMarkup{
    type = 'inline',
    data = {
    {
    {text = '‹ الغاء ›', data = msg.sender_id.user_id..'/cancelamr'},
    },
    }
    }
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسل الان الكلمه لحذفها من الردود .*","md", false, false, false, false, reply_markup)
end
if text == ("ردود المدير") then
local list = redis:smembers(bot_id.."List:Rp:content"..msg.chat_id)
ext = "⤈︙ قائمه ردود المدير .\n  ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(list) do
if redis:get(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..v) then
db = "بصمه 📢"
elseif redis:get(bot_id.."Rp:content:Text"..msg.chat_id..":"..v) then
db = "رساله ✉"
elseif redis:get(bot_id.."Rp:content:Photo"..msg.chat_id..":"..v) then
db = "صوره 🎇"
elseif redis:get(bot_id.."Rp:content:Sticker"..msg.chat_id..":"..v) then
db = "ملصق 🃏"
elseif redis:get(bot_id.."Rp:content:Video"..msg.chat_id..":"..v) then
db = "فيديو 🎬"
elseif redis:get(bot_id.."Rp:content:Animation"..msg.chat_id..":"..v) then
db = "انيميشن 🎨"
elseif redis:get(bot_id.."Rp:Manager:File"..msg.chat_id..":"..v) then
db = "ملف ⤈︙  "
elseif redis:get(bot_id.."Rp:content:Audio"..msg.chat_id..":"..v) then
db = "اغنيه 🎵"
end
ext = ext..""..k.." -> "..v.." -> (" ..db.. ")\n"
end
if #list == 0 then
ext = "⤈︙ لا توجد ردود مضافه ."
end
bot.sendText(msg.chat_id,msg.id,"["..ext.."]","md",true)  
end
end
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
if Constructor(msg) then
if text == "مسح الاوامر المضافه" then 
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم مسح الاوامر المضافه*","md",true)
local list = redis:smembers(bot_id.."List:Command:"..msg.chat_id)
for k,v in pairs(list) do
redis:del(bot_id..":"..msg.chat_id..":Command:"..v)
end
redis:del(bot_id.."List:Command:"..msg.chat_id)
end
if text == "الاوامر المضافه" then
local list = redis:smembers(bot_id.."List:Command:"..msg.chat_id)
ext = "*⤈︙ قائمة الاوامر المضافه\n  ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n*"
for k,v in pairs(list) do
Com = redis:get(bot_id..":"..msg.chat_id..":Command:"..v)
if Com then 
ext = ext..""..k..": (`"..v.."`) - (`"..Com.."`)\n"
else
ext = ext..""..k..": (*"..v.."*) \n"
end
end
if #list == 0 then
ext = "*⤈︙ لا توجد اوامر مضافه في البوت .*"
end
bot.sendText(msg.chat_id,msg.id,ext,"md",true)
end
end
----------------------------------------------------------------------------------------------------
if programmer(msg) then
if text == ("مسح الردود العامه") then 
if not devB(msg.sender_id.user_id) then 
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ الامر يخص المطور الاساسي فقط .* ',"md",true)  
end
if not redis:get(bot_id.."Zepra:Set:Rd"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"*⤈︙ الردود العامه معطله بواسطه المطور الاساسي .*","md",true)
end
local list = redis:smembers(bot_id.."Zepra:List:Rd:Sudo")
for k,v in pairs(list) do
redis:del(bot_id.."Zepra:Add:Rd:Sudo:Gif"..v)   
redis:del(bot_id.."Zepra:Add:Rd:Sudo:vico"..v)   
redis:del(bot_id.."Zepra:Add:Rd:Sudo:stekr"..v)     
redis:del(bot_id.."Zepra:Add:Rd:Sudo:Text"..v)   
redis:del(bot_id.."Zepra:Add:Rd:Sudo:Photo"..v)
redis:del(bot_id.."Zepra:Add:Rd:Sudo:Video"..v)
redis:del(bot_id.."Zepra:Add:Rd:Sudo:File"..v)
redis:del(bot_id.."Zepra:Add:Rd:Sudo:Audio"..v)
redis:del(bot_id.."Zepra:Add:Rd:Sudo:video_note"..v)
redis:del(bot_id.."Zepra:List:Rd:Sudo")
end
return bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم ازالة قائمه الردود العامه بنجاح .*","md",true)  
end
if text == ("الردود العامه") then 
if not devB(msg.sender_id.user_id) then 
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ الامر يخص المطور الاساسي فقط .* ',"md",true)  
end
if not redis:get(bot_id.."Zepra:Set:Rd"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"*⤈︙ الردود العامه معطله بواسطه المطور الاساسي .*","md",true)
end
local list = redis:smembers(bot_id.."Zepra:List:Rd:Sudo")
text = "\n⤈︙ قائمة الردود العامه .\nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ \n"
for k,v in pairs(list) do
if redis:get(bot_id.."Zepra:Add:Rd:Sudo:Gif"..v) then
db = "متحركه 🎭"
elseif redis:get(bot_id.."Zepra:Add:Rd:Sudo:vico"..v) then
db = "بصمه 📢"
elseif redis:get(bot_id.."Zepra:Add:Rd:Sudo:stekr"..v) then
db = "ملصق 🃏"
elseif redis:get(bot_id.."Zepra:Add:Rd:Sudo:Text"..v) then
db = "رساله ✉"
elseif redis:get(bot_id.."Zepra:Add:Rd:Sudo:Photo"..v) then
db = "صوره 🎇"
elseif redis:get(bot_id.."Zepra:Add:Rd:Sudo:Video"..v) then
db = "فيديو 📹"
elseif redis:get(bot_id.."Zepra:Add:Rd:Sudo:File"..v) then
db = "ملف  :"
elseif redis:get(bot_id.."Zepra:Add:Rd:Sudo:Audio"..v) then
db = "اغنيه 🎵"
elseif redis:get(bot_id.."Zepra:Add:Rd:Sudo:video_note"..v) then
db = "بصمه فيديو 🎥"
end
text = text..""..k.." » (" ..v.. ") » (" ..db.. ")\n"
end
redis:del(bot_id.."List:Rp:all:content")
if #list == 0 then
ext = "*⤈︙ لا توجد ردود عامه في البوت .*"
end
bot.sendText(msg.chat_id,msg.id,ext,"md",true)  
end
if text == "اضف رد عام" then 
if not devB(msg.sender_id.user_id) then 
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ الامر يخص المطور الاساسي فقط .* ',"md",true)  
end
redis:set(bot_id.."Zepra:Set:Rd"..msg.sender_id.user_id..":"..msg.chat_id,true)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '‹ الغاء ›', data =msg.sender_id.user_id..'/cancelamr'}
},
}
}
return bot.sendText(msg.chat_id,msg.id,"⤈︙ ارسل الان اسم الرد لاضافته في الردود العامه .", 'md', false, false, false, false, reply_markup)
end
if text == "مسح رد عام" or text == "حذف رد عام" then 
if not devB(msg.sender_id.user_id) then 
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ الامر يخص المطور الاساسي فقط .* ',"md",true)  
end
redis:set(bot_id.."Zepra:Set:On"..msg.sender_id.user_id..":"..msg.chat_id,true)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '‹ الغاء ›', data =msg.sender_id.user_id..'/cancelamr'}
},
}
}
return bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسل اسم الرد ليتم ازالته من الردود العامه .*", 'md', false, false, false, false, reply_markup)
end
end
if text and redis:get(bot_id.."Zepra:Set:On"..msg.sender_id.user_id..":"..msg.chat_id) == "true" then
if text:match("^(.*)$") then
list = {"Add:Rd:Sudo:video_note","Add:Rd:Sudo:Audio","Add:Rd:Sudo:File","Add:Rd:Sudo:Video","Add:Rd:Sudo:Photo","Add:Rd:Sudo:Text","Add:Rd:Sudo:stekr","Add:Rd:Sudo:vico","Add:Rd:Sudo:Gif"}
for k,v in pairs(list) do
redis:del(bot_id..'Zepra:'..v..text)
end
redis:del(bot_id.."Zepra:Set:On"..msg.sender_id.user_id..":"..msg.chat_id)
redis:srem(bot_id.."Zepra:List:Rd:Sudo", text)
bot.sendText(msg.chat_id,msg.id,"⤈︙ تم ازالة الرد من الردود العامه بنجاح .")  
return false
end
end
----------------------------------------------------------------------------------------------------
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array"..msg.sender_id.user_id..":"..msg.chat_id) == 'true' then
redis:set(bot_id..'Set:array'..msg.sender_id.user_id..':'..msg.chat_id,'true1')
redis:set(bot_id..'Text:array'..msg.sender_id.user_id..':'..msg.chat_id, text)
redis:del(bot_id.."Add:Rd:array:Text"..text..msg.chat_id)   
redis:sadd(bot_id..'List:array'..msg.chat_id..'', text)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسل الكلمه الرد الذي تريد اضافتها*","md",true)  
return false
end
end
if text and redis:get(bot_id..'Set:array'..msg.sender_id.user_id..':'..msg.chat_id) == 'true1' then
local test = redis:get(bot_id..'Text:array'..msg.sender_id.user_id..':'..msg.chat_id..'')
text = text:gsub('"','') 
text = text:gsub("'",'') 
text = text:gsub('`','') 
text = text:gsub('*','') 
redis:sadd(bot_id.."Add:Rd:array:Text"..test..msg.chat_id,text)  
reply_ad = bot.replyMarkup{
type = 'inline',data = {
{{text="⤈︙ اضغط هنا لانهاء الاضافه ⤈︙",data="EndAddarray"..msg.sender_id.user_id}},
}
}
return bot.sendText(msg.chat_id,msg.id,' *⤈︙ تم حفظ الرد يمكنك ارسال رد اخر او الانهاء من خلال الزر بالاسفل*',"md",true, false, false, false, reply_ad)
end
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array:Ssd"..msg.sender_id.user_id..":"..msg.chat_id) == 'dttd' then
redis:del(bot_id.."Set:array:Ssd"..msg.sender_id.user_id..":"..msg.chat_id)
gery = redis:get(bot_id.."Set:array:addpu"..msg.sender_id.user_id..":"..msg.chat_id)
if not redis:sismember(bot_id.."Add:Rd:array:Text"..gery..msg.chat_id,text) then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ لا يوجد رد متعدد* ","md",true)  
return false
end
redis:srem(bot_id.."Add:Rd:array:Text"..gery..msg.chat_id,text)
bot.sendText(msg.chat_id,msg.id,' *⤈︙ تم مسحه بنجاح* ',"md",true)  
end
end
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array:Ssd"..msg.sender_id.user_id..":"..msg.chat_id) == 'delrd' then
redis:del(bot_id.."Set:array:Ssd"..msg.sender_id.user_id..":"..msg.chat_id)
if not redis:sismember(bot_id..'List:array'..msg.chat_id,text) then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ لا يوجد رد متعدد* ","md",true)  
return false
end
redis:set(bot_id.."Set:array:addpu"..msg.sender_id.user_id..":"..msg.chat_id,text)
redis:set(bot_id.."Set:array:Ssd"..msg.sender_id.user_id..":"..msg.chat_id,"dttd")
bot.sendText(msg.chat_id,msg.id,' *⤈︙ قم بارسال الرد الذي تريد مسحه منه* ',"md",true)  
return false
end
end
if text == "مسح رد من متعدد" and Owner(msg) then
redis:set(bot_id.."Set:array:Ssd"..msg.sender_id.user_id..":"..msg.chat_id,"delrd")
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسل كلمة الرد *","md",true)  
return false
end
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array:rd"..msg.sender_id.user_id..":"..msg.chat_id) == 'delrd' then
redis:del(bot_id.."Set:array:rd"..msg.sender_id.user_id..":"..msg.chat_id)
redis:del(bot_id.."Add:Rd:array:Text"..text..msg.chat_id)
redis:srem(bot_id..'List:array'..msg.chat_id, text)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم مسح الرد المتعدد *","md",true)  
return false
end
end
if text == "مسح رد متعدد" and Owner(msg) then
redis:set(bot_id.."Set:array:rd"..msg.sender_id.user_id..":"..msg.chat_id,"delrd")
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسل الان الكلمه لمسحها من الردود*","md",true)  
return false
end
if text == ("الردود المتعدده") and Owner(msg) then
local list = redis:smembers(bot_id..'List:array'..msg.chat_id..'')
t = Reply_Status(msg.sender_id.user_id,"\n *ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ *\n*⤈︙ قائمه الردود المتعدده*\n  *ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ *\n").yu
for k,v in pairs(list) do
t = t..""..k..">> (" ..v.. ") » ( رساله )\n"
end
if #list == 0 then
t = "*⤈︙ لا يوجد ردود متعدده*"
end
bot.sendText(msg.chat_id,msg.id,t,"md",true)  
end
if text == ("مسح الردود المتعدده") and BasicConstructor(msg) then   
local list = redis:smembers(bot_id..'List:array'..msg.chat_id)
for k,v in pairs(list) do
redis:del(bot_id.."Add:Rd:array:Text"..v..msg.chat_id)   
redis:del(bot_id..'List:array'..msg.chat_id)
end
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم مسح الردود المتعدده*","md",true)  
end
if text == "اضف رد متعدد" and Administrator(msg) then   
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسل الان الكلمه لاضافتها في الردود*","md",true)
redis:set(bot_id.."Set:array"..msg.sender_id.user_id..":"..msg.chat_id,true)
return false 
end
----------------
if programmer(msg) then
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:arrayy"..msg.sender_id.user_id..":"..msg.chat_id) == 'true' then
redis:set(bot_id..'Set:arrayy'..msg.sender_id.user_id..':'..msg.chat_id,'true1')
redis:set(bot_id..'Text:arrayy'..msg.sender_id.user_id, text)
redis:del(bot_id.."Add:Rd:array:Textt"..text)   
redis:sadd(bot_id..'List:arrayy', text)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسل الكلمه الرد الذي تريد اضافتها*","md",true)  
return false
end
end
if text and redis:get(bot_id..'Set:arrayy'..msg.sender_id.user_id..':'..msg.chat_id) == 'true1' then
local test = redis:get(bot_id..'Text:arrayy'..msg.sender_id.user_id)
text = text:gsub('"','') 
text = text:gsub("'",'') 
text = text:gsub('`','') 
text = text:gsub('*','') 
redis:sadd(bot_id.."Add:Rd:array:Textt"..test,text)  
reply_ad = bot.replyMarkup{
type = 'inline',data = {
{{text="⤈︙ اضغط هنا لانهاء الاضافه ⤈︙",data="EndAddarrayy"..msg.sender_id.user_id}},
}
}
return bot.sendText(msg.chat_id,msg.id,' *⤈︙ تم حفظ الرد يمكنك ارسال رد اخر او الانهاء من خلال الزر بالاسفل*',"md",true, false, false, false, reply_ad)
end
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array:Ssdd"..msg.sender_id.user_id..":"..msg.chat_id) == 'dttd' then
redis:del(bot_id.."Set:array:Ssdd"..msg.sender_id.user_id..":"..msg.chat_id)
gery = redis:get(bot_id.."Set:array:addpuu"..msg.sender_id.user_id..":"..msg.chat_id)
if not redis:sismember(bot_id.."Add:Rd:array:Textt"..gery,text) then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ لا يوجد رد متعدد* ","md",true)  
return false
end
redis:srem(bot_id.."Add:Rd:array:Textt"..gery,text)
bot.sendText(msg.chat_id,msg.id,' *⤈︙ تم مسحه بنجاح* ',"md",true)  
end
end
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array:Ssdd"..msg.sender_id.user_id..":"..msg.chat_id) == 'delrd' then
redis:del(bot_id.."Set:array:Ssdd"..msg.sender_id.user_id..":"..msg.chat_id)
if not redis:sismember(bot_id..'List:arrayy',text) then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ لا يوجد رد متعدد* ","md",true)  
return false
end
redis:set(bot_id.."Set:array:addpuu"..msg.sender_id.user_id..":"..msg.chat_id,text)
redis:set(bot_id.."Set:array:Ssdd"..msg.sender_id.user_id..":"..msg.chat_id,"dttd")
bot.sendText(msg.chat_id,msg.id,' *⤈︙ قم بارسال الرد الذي تريد مسحه منه* ',"md",true)  
return false
end
end
if text == "مسح رد من متعدد عام" then
redis:set(bot_id.."Set:array:Ssdd"..msg.sender_id.user_id..":"..msg.chat_id,"delrd")
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسل كلمة الرد *","md",true)  
return false
end
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array:rdd"..msg.sender_id.user_id..":"..msg.chat_id) == 'delrd' then
redis:del(bot_id.."Set:array:rdd"..msg.sender_id.user_id..":"..msg.chat_id)
redis:del(bot_id.."Add:Rd:array:Textt"..text)
redis:srem(bot_id..'List:arrayy', text)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم مسح الرد المتعدد عام *","md",true)  
return false
end
end
if text == "مسح رد متعدد عام" then
redis:set(bot_id.."Set:array:rdd"..msg.sender_id.user_id..":"..msg.chat_id,"delrd")
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسل الان الكلمه لمسحها من الردود*","md",true)  
return false
end
if text == ("الردود المتعدده العامه") then
local list = redis:smembers(bot_id..'List:arrayy')
t = Reply_Status(msg.sender_id.user_id,"\n *ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ *\n*⤈︙ قائمه الردود المتعدده عام*\n  *ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ *\n").yu
for k,v in pairs(list) do
t = t..""..k..">> (" ..v.. ") » ( رساله )\n"
end
if #list == 0 then
t = "*⤈︙ لا توجد ردود متعدده عامه في البوت .*"
end
bot.sendText(msg.chat_id,msg.id,t,"md",true)  
end
if text == ("مسح الردود المتعدده العامه") then   
local list = redis:smembers(bot_id..'List:arrayy')
for k,v in pairs(list) do
redis:del(bot_id.."Add:Rd:array:Textt"..v)   
redis:del(bot_id..'List:arrayy')
end
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم مسح الردود المتعدده العامه بنجاح .*","md",true)  
end
if text == "اضف رد متعدد عام" then   
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسل الان الكلمه لاضافتها في الردود .*","md",true)
redis:set(bot_id.."Set:arrayy"..msg.sender_id.user_id..":"..msg.chat_id,true)
return false 
end
end
-------------------------------
if programmer(msg) then
if msg.content.text and text:match("^(.*)$") then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Commandd:sett") == "true1" then
text = text:gsub('"',"")
text = text:gsub('"',"")
text = text:gsub("`","")
text = text:gsub("*","") 
text = text:gsub("_","")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Commandd:sett")
redis:set(bot_id..":Commandd:"..text,redis:get(bot_id..":"..msg.sender_id.user_id..":Commandd:Textt"))
redis:sadd(bot_id.."Listt:Commandd", text)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم حفظ الامر *","md",true)
redis:del(bot_id..":"..msg.sender_id.user_id..":Commandd:Textt")
return false
end
end
if msg.content.text and text:match("^(.*)$") then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Commandd:sett") == "true" then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Commandd:sett","true1")
redis:set(bot_id..":"..msg.sender_id.user_id..":Commandd:Textt",text)
redis:del(bot_id..":Commandd:"..text)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسلي الامر الجديد*","md",true)  
return false
end
end
if text == "مسح امر عام" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسلي الامر*","md",true)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Commandd:dell",true)
end
if text == "اضف امر عام" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسلي الامر القديم*","md",true)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Commandd:sett",true)
end
if text == "مسح الاوامر المضافه عام" or text == "مسح الاوامر المضافه العامه" then 
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم مسح الاوامر المضافه عام*","md",true)
local list = redis:smembers(bot_id.."Listt:Commandd")
for k,v in pairs(list) do
redis:del(bot_id..":Commandd:"..v)
end
redis:del(bot_id.."Listt:Commandd")
end
if text == "الاوامر المضافه عام" or text == "الاوامر المضافه العامه" then
local list = redis:smembers(bot_id.."Listt:Commandd")
ext = "*⤈︙ قائمة الاوامر المضافه عام\n  ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ \n*"
for k,v in pairs(list) do
Com = redis:get(bot_id..":Commandd:"..v)
if Com then 
ext = ext..""..k..": (`"..v.."`) - (`"..Com.."`)\n"
else
ext = ext..""..k..": (*"..v.."*) \n"
end
end
if #list == 0 then
ext = "*⤈︙  مافيه اوامر مضافة عام*"
end
bot.sendText(msg.chat_id,msg.id,ext,"md",true)
end
end
-------------------------------
if Owner(msg) then
if text == "ترتيب الاوامر" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
redis:set(bot_id..":"..msg.chat_id..":Command:حذ","حذف رد")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"حذ")
redis:set(bot_id..":"..msg.chat_id..":Command:ا","ايدي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ا")
redis:set(bot_id..":"..msg.chat_id..":Command:غ","غنيلي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"غ")
redis:set(bot_id..":"..msg.chat_id..":Command:ش","شعر")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ش")
redis:set(bot_id..":"..msg.chat_id..":Command:ب","راب")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ب")
redis:set(bot_id..":"..msg.chat_id..":Command:رم","ريمكس")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"رم")
redis:set(bot_id..":"..msg.chat_id..":Command:مم","ميمز")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"مم")
redis:set(bot_id..":"..msg.chat_id..":Command:ق","قرأن")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ق")
redis:set(bot_id..":"..msg.chat_id..":Command:تغ","تغير الايدي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تغ")
redis:set(bot_id..":"..msg.chat_id..":Command:تاك","تاك للكل")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تاك")
redis:set(bot_id..":"..msg.chat_id..":Command:ت","تثبيت")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ت")
redis:set(bot_id..":"..msg.chat_id..":Command:رس","مسح رسائلي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"رس")
redis:set(bot_id..":"..msg.chat_id..":Command:ر","الرابط")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ر")
redis:set(bot_id..":"..msg.chat_id..":Command:سح","مسح سحكاتي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"سح")
redis:set(bot_id..":"..msg.chat_id..":Command:رر","ردود المدير")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"رر")
redis:set(bot_id..":"..msg.chat_id..":Command:رد","اضف رد")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"رد")
redis:set(bot_id..":"..msg.chat_id..":Command:،،","مسح المكتومين")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"،،")
redis:set(bot_id..":"..msg.chat_id..":Command:تفع","تفعيل الايدي بالصوره")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تفع")
redis:set(bot_id..":"..msg.chat_id..":Command:تعط","تعطيل الايدي بالصوره")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تعط")
redis:set(bot_id..":"..msg.chat_id..":Command:تك","تنزيل الكل")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تك")
redis:set(bot_id..":"..msg.chat_id..":Command:ثانوي","رفع مطور ثانوي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ثانوي")
redis:set(bot_id..":"..msg.chat_id..":Command:اس","رفع منشئ اساسي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"اس")
redis:set(bot_id..":"..msg.chat_id..":Command:من","رفع منشئ")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"من")
redis:set(bot_id..":"..msg.chat_id..":Command:مد","رفع مدير")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"مد")
redis:set(bot_id..":"..msg.chat_id..":Command:اد","رفع ادمن")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"اد")
redis:set(bot_id..":"..msg.chat_id..":Command:مط","رفع مطور")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"مط")
redis:set(bot_id..":"..msg.chat_id..":Command:امر","اضف امر")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"امر")
redis:set(bot_id..":"..msg.chat_id..":Command:م","رفع مميز")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"م")
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم ترتيب الاوامر بالشكل التالي . \n⤈︙ تفعيل الايدي بالصوره - تفع . \n⤈︙ تعطيل الايدي بالصوره - تعط . \n⤈︙ رفع مطور ثانوي - ثانوي . \n⤈︙ رفع مطور - مط . \n⤈︙ رفع منشئ اساسي - اس . \n⤈︙ رفع منشئ - من . \n⤈︙ رفع مدير - مد . \n⤈︙ رفع ادمن - اد . \n⤈︙ رفع مميز - م . \n⤈︙ تنزيل الكل - تك . \n⤈︙ تغير الايدي - تغ . \n⤈︙ تاك للكل - تاك . \n⤈︙ تثبيت - ت . \n⤈︙ الرابط - ر . \n⤈︙ مسح رسائلي - رس . \n⤈︙ مسح سحكاتي - سح . \n⤈︙ مسح المكتومين - ،، . \n⤈︙ اضف رد - رد .\n⤈︙ حذف رد - حذ .\n⤈︙ غنيلي - غ . \n⤈︙ شعر - ش . \n⤈︙ ميمز - مم . \n⤈︙ اضف امر - امر .\n⤈︙ ريمكس - رم . \n⤈︙ راب - ب . \n⤈︙ قرأن - ق .\n⤈︙ ردود المدير - رر .*","md",true, false, false, false, reply_markup)
end
end
if Administrator(msg) then
if text == 'مسح البوتات' or text == 'مسح بوتات' or text == 'طرد البوتات' then            
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ البوت لا يمتلك صلاحيه حظر الاعضاء* ',"md",true)  
return false
end
local Info = bot.searchChatMembers(msg.chat_id, "*", 200)
local members = Info.members
i = 0
for k, v in pairs(members) do
UserInfo = bot.getUser(v.member_id.user_id) 
if UserInfo.type.luatele == "userTypeBot" then 
if bot.getChatMember(msg.chat_id,v.member_id.user_id).status.luatele ~= "chatMemberStatusAdministrator" then
bot.setChatMemberStatus(msg.chat_id,v.member_id.user_id,'banned',0)
i = i + 1
end
end
end
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم مسح ( "..i.." ) من البوتات في الكروب*","md",true)  
end
if text == 'البوتات' then  
local Info = bot.searchChatMembers(msg.chat_id, "*", 200)
local members = Info.members
ls = "*⤈︙ قائمه البوتات في الكروب\n  *ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ *\n⤈︙ العلامه 《 *★ * 》 تدل على ان البوت مشرف*\n *ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ *\n"
i = 0
for k, v in pairs(members) do
UserInfo = bot.getUser(v.member_id.user_id) 
if UserInfo.type.luatele == "userTypeBot" then 
sm = bot.getChatMember(msg.chat_id,v.member_id.user_id)
if sm.status.luatele == "chatMemberStatusAdministrator" then
i = i + 1
ls = ls..'*'..(i)..' - *@['..UserInfo.username..'] 《 `★` 》\n'
else
i = i + 1
ls = ls..'*'..(i)..' - *@['..UserInfo.username..']\n'
end
end
end
bot.sendText(msg.chat_id,msg.id,ls,"md",true)  
end
if text == "الاوامر" then    
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "‹ 1 ›" ,data="Amr_"..msg.sender_id.user_id.."_1"},{text ="‹ 2 ›",data="Amr_"..msg.sender_id.user_id.."_2"}},
{{text ="‹ 3 ›",data="Amr_"..msg.sender_id.user_id.."_3"}},
{{text ="‹ 4 ›",data="Amr_"..msg.sender_id.user_id.."_4"},{text ="‹ 5 ›",data="Amr_"..msg.sender_id.user_id.."_5"}},
{{text ="‹ 6 ›",data="Amr_"..msg.sender_id.user_id.."_6"},{text ="‹ 7 ›",data="Amr_"..msg.sender_id.user_id.."_7"}},
{{text = '‹ اخفاء ›', data = msg.sender_id.user_id..'/delAmr'}}, 

}
}
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اوامر البوت الرئيسيه .\n * ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*\n⤈︙ م1 - اوامر الحمايه .\n⤈︙ م2 - اوامر الاعدادات .\n⤈︙ م3 - اوامر المدراء .\n⤈︙ م4 - اوامر اخرى .\n⤈︙ م5 - اوامر المالكين .\n⤈︙ م6 - اوامر التسليه .\n⤈︙ م7 - العاب السورس .*","md", true, false, false, false, reply_markup)
end
if text == "العاب السورس" then    
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "‹ العاب السورس ›" ,data="Ammr_"..msg.sender_id.user_id.."_20"}},
{{text = '‹ اخفاء ›', data = msg.sender_id.user_id..'/delAmr'}}, 

}
}
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اهلا بك عزيزي الادمن . \n⤈︙ قائمه العاب السورس في الإسفل .*","md", true, false, false, false, reply_markup)
end
if text == "الاعدادات" or text == "اوامر القفل" then    
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "‹ الكيبورد ›" ,data="GetSe_"..msg.sender_id.user_id.."_Keyboard"},{text = GetSetieng(msg.chat_id).Keyboard ,data="GetSe_"..msg.sender_id.user_id.."_Keyboard"}},
{{text = "‹ الملصقات ›" ,data="GetSe_"..msg.sender_id.user_id.."_messageSticker"},{text =GetSetieng(msg.chat_id).messageSticker,data="GetSe_"..msg.sender_id.user_id.."_messageSticker"}},
{{text = "‹ الاغاني ›" ,data="GetSe_"..msg.sender_id.user_id.."_messageVoiceNote"},{text =GetSetieng(msg.chat_id).messageVoiceNote,data="GetSe_"..msg.sender_id.user_id.."_messageVoiceNote"}},
{{text = "‹ الانكليزي ›" ,data="GetSe_"..msg.sender_id.user_id.."_WordsEnglish"},{text =GetSetieng(msg.chat_id).WordsEnglish,data="GetSe_"..msg.sender_id.user_id.."_WordsEnglish"}},
{{text = "‹ الفارسيه ›" ,data="GetSe_"..msg.sender_id.user_id.."_WordsPersian"},{text =GetSetieng(msg.chat_id).WordsPersian,data="GetSe_"..msg.sender_id.user_id.."_WordsPersian"}},
{{text = "‹ الدخول ›" ,data="GetSe_"..msg.sender_id.user_id.."_JoinByLink"},{text =GetSetieng(msg.chat_id).JoinByLink,data="GetSe_"..msg.sender_id.user_id.."_JoinByLink"}},
{{text = "‹ الصوت ›" ,data="GetSe_"..msg.sender_id.user_id.."_messagePhoto"},{text =GetSetieng(msg.chat_id).messagePhoto,data="GetSe_"..msg.sender_id.user_id.."_messagePhoto"}},
{{text = "‹ الفيديو ›" ,data="GetSe_"..msg.sender_id.user_id.."_messageVideo"},{text =GetSetieng(msg.chat_id).messageVideo,data="GetSe_"..msg.sender_id.user_id.."_messageVideo"}},
{{text = "‹ الجهات ›" ,data="GetSe_"..msg.sender_id.user_id.."_messageContact"},{text =GetSetieng(msg.chat_id).messageContact,data="GetSe_"..msg.sender_id.user_id.."_messageContact"}},
{{text = "‹ السيلفي ›" ,data="GetSe_"..msg.sender_id.user_id.."_messageVideoNote"},{text =GetSetieng(msg.chat_id).messageVideoNote,data="GetSe_"..msg.sender_id.user_id.."_messageVideoNote"}},
{{text = "↪️" ,data="GetSeBk_"..msg.sender_id.user_id.."_1"}},
}
}
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اعدادات المجموعه .\n⤈︙ اوامر القفل - والفتح .*","md", true, false, false, false, reply_markup)
end
if text == "م1" or text == "م١" or text == "اوامر الحمايه" then    
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اوامر الحمايه اتبع مايلي .\n *ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉  *\n⤈︙ قفل ، فتح - الامر .\n- تستطيع قفل حمايه كما يلي .\n- { بالتقيد ، بالطرد ، بالكتم ، بالتقييد }\n *ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉  *\n⤈︙ تاك . \n⤈︙ القناه .\n⤈︙ الصور .\n⤈︙ الرابط .\n⤈︙ الفشار .\n⤈︙ الموقع .\n⤈︙ التكرار .\n⤈︙ التفليش .\n⤈︙ الاباحي .\n⤈︙ الكفر .\n⤈︙ الفيديو .\n⤈︙ الدخول .\n⤈︙ الاضافه .\n⤈︙ الاغاني .\n⤈︙ الصوت .\n⤈︙ الملفات .\n⤈︙ الرسائل .\n⤈︙ الدردشه .\n⤈︙ الجهات .\n⤈︙ السيلفي .\n⤈︙ التثبيت .\n⤈︙ الشارحه .\n⤈︙ الكلايش .\n⤈︙ البوتات .\n⤈︙ التوجيه .\n⤈︙ التعديل .\n⤈︙ الانلاين .\n⤈︙ المعرفات .\n⤈︙ الكيبورد .\n⤈︙ الفارسيه .\n⤈︙ الانكليزيه .\n⤈︙ الاستفتاء .\n⤈︙ الملصقات .\n⤈︙ الاشعارات .\n⤈︙ الماركداون .\n⤈︙ المتحركات .*","md",true)
elseif text == "م2" or text == "م٢" then    
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ⤈︙ اعدادات المجموعه . ⬇️ .\n *ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉  *\n⤈︙ مسح الرتب .\n⤈︙ الرابط .\n⤈︙ مسح الرابط .\n⤈︙ وضع رابط .\n⤈︙ تعين الرابط .\n⤈︙ فحص البوت .\n⤈︙ الترحيب .\n⤈︙ مسح الترحيب .\n⤈︙ وضع ترحيب .\n⤈︙ تنظيف التعديل .\n⤈︙ تنظيف الميديا .\n⤈︙ مسح الميديا .\n⤈︙ تعين قوانين .\n⤈︙ مسح القوانين .\n⤈︙ وضع قوانين .\n⤈︙  تعين الايدي .\n⤈︙ مسح الايدي .\n⤈︙ تغير الايدي .\n⤈︙ تغيير اسم المجموعه .\n⤈︙ تغيير الوصف .\n⤈︙ رفع الادمنيه .\n⤈︙ الالعاب الاحترافيه .\n⤈︙ المجموعه .*","md",true)
elseif text == "م3" or text == "م٣" then    
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اوامر التفعيل والتعطيل .\n⤈︙ تفعيل/تعطيل الامر اسفل .\n *ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉  *\n⤈︙ التسليه .\n⤈︙ الالعاب الاحترافيه .\n⤈︙ الطرد .\n⤈︙ الحظر .\n⤈︙ الرفع .\n⤈︙ التسليه .\n⤈︙ المسح التلقائي .\n⤈︙ ٴall .\n⤈︙ منو ضافني .\n⤈︙ تفعيل الردود .\n⤈︙ الايدي بالصوره .\n⤈︙ الايدي .\n⤈︙ التنظيف .\n⤈︙ الترحيب .\n⤈︙ الرابط .\n⤈︙ البايو .\n⤈︙ صورتي .\n⤈︙ الالعاب .*","md",true)
elseif text == "م4" or text == "م٤" then    
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اوامر اخرى .\n *ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉  *\n⤈︙ الالعاب الاحترافيه .\n⤈︙ المجموعه .\n⤈︙ الرابط .\n⤈︙ اسمي .\n⤈︙ ايديي .\n⤈︙ مسح نقاطي .\n⤈︙ نقاطي .\n⤈︙ مسح رسائلي .\n⤈︙ رسائلي .\n⤈︙ مسح جهاتي .\n⤈︙ مسح بالرد .\n⤈︙ تفاعلي .\n⤈︙ جهاتي .\n⤈︙ مسح سحكاتي .\n⤈︙ سحكاتي .\n⤈︙ رتبتي .\n⤈︙ معلوماتي .\n⤈︙ المنشئ .\n⤈︙ رفع المنشئ .\n⤈︙ البايو/نبذتي .\n⤈︙ التاريخ/الساعه .\n⤈︙ رابط الحذف .\n⤈︙ الالعاب .\n⤈︙ منع بالرد .\n⤈︙ منع .\n⤈︙ تنظيف + عدد .\n⤈︙ قائمه المنع .\n⤈︙ مسح قائمه المنع .\n⤈︙ مسح الاوامر المضافه .\n⤈︙ الاوامر المضافه .\n⤈︙ ترتيب الاوامر .\n⤈︙ اضف امر .\n⤈︙ حذف امر .\n⤈︙ اضف رد .\n⤈︙ حذف رد .\n⤈︙ ردود المدير .\n⤈︙ مسح الردود المتعدده .\n⤈︙ الردود المتعدده .\n⤈︙ وضع عدد المسح +رقم .\n⤈︙ ٴall .\n⤈︙ غنيلي،فلم، متحركه، فيديو، رمزيه،انمي،ريمكس،شعر،ميمز،راب .\n⤈︙ مسح ردود المدير .\n⤈︙ تغير رد العضو.المميز.الادمن.المدير.المنشئ.المنشئ الاساسي.المالك.المطو  .\n⤈︙ حذف رد العضو.المميز.الادمن.المدير.المنشئ.المنشئ الاساسي.المالك.المطور .*","md",true)
elseif text == "قفل الكل" or text == "قفل التفليش" or text == "قفل الاباحي" or text == "قفل الكفر" then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.."* بنجاح . ").by,"md",true)
list ={"Spam","Edited","Hashtak","via_bot_user_id","messageChatAddMembers","forward_info","Links","Markdaun","WordsFshar","Spam","Tagservr","Username","Keyboard","messagePinMessage","messageSenderChat","Cmd","messageLocation","messageContact","messageVideoNote","messagePoll","messageAudio","messageDocument","messageAnimation","messageSticker","messageVoiceNote","WordsPersian","messagePhoto","messageVideo"}
for i,lock in pairs(list) do
redis:set(bot_id..":"..msg.chat_id..":settings:"..lock,"del")    
end
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","del")  
elseif text == "فتح الكل" or text == "فتح التفليش" or text == "فتح الاباحي" or text == "فتح الكفر" and BasicConstructor(msg) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.."* بنجاح . ").by,"md",true)
list ={"Edited","Hashtak","via_bot_user_id","messageChatAddMembers","forward_info","Links","Markdaun","WordsFshar","Spam","Tagservr","Username","Keyboard","messagePinMessage","messageSenderChat","Cmd","messageLocation","messageContact","messageVideoNote","messageText","message","messagePoll","messageAudio","messageDocument","messageAnimation","AddMempar","messageSticker","messageVoiceNote","WordsPersian","WordsEnglish","JoinByLink","messagePhoto","messageVideo"}
for i,unlock in pairs(list) do 
redis:del(bot_id..":"..msg.chat_id..":settings:"..unlock)    
end
redis:hdel(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User")
elseif text == "قفل التكرار" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم قفل "..text.." .*").by,"md",true)
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","del")  
elseif text == "فتح التكرار" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم فتح "..text.." .*").by,"md",true)
redis:hdel(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User")  
elseif text == "قفل التكرار بالطرد" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم قفل "..text.." .*").by,"md",true)
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","kick")  
elseif text == "قفل التكرار بالتقييد" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم قفل "..text.." .*").by,"md",true)
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","ked")  
elseif text == "قفل التكرار بالكتم" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم قفل "..text.." .*").by,"md",true)  
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","ktm")  
return false
end  
if text and text:match("^قفل (.*)$") and tonumber(msg.reply_to_message_id) == 0 then
TextMsg = text:match("^قفل (.*)$")
if text:match("^(.*)بالكتم$") then
setTyp = "ktm"
elseif text:match("^(.*)بالتقيد$") or text:match("^(.*)بالتقييد$") then  
setTyp = "ked"
elseif text:match("^(.*)بالطرد$") then 
setTyp = "kick"
else
setTyp = "del"
end
if msg.content.text then 
if TextMsg == 'الصور' or TextMsg == 'الصور بالكتم' or TextMsg == 'الصور بالطرد' or TextMsg == 'الصور بالتقييد' or TextMsg == 'الصور بالتقيد' then
srt = "messagePhoto"
elseif TextMsg == 'الفيديو' or TextMsg == 'الفيديو بالكتم' or TextMsg == 'الفيديو بالطرد' or TextMsg == 'الفيديو بالتقييد' or TextMsg == 'الفيديو بالتقيد' then
srt = "messageVideo"
elseif TextMsg == 'الفارسيه' or TextMsg == 'الفارسيه بالكتم' or TextMsg == 'الفارسيه بالطرد' or TextMsg == 'الفارسيه بالتقييد' or TextMsg == 'الفارسيه بالتقيد' then
srt = "WordsPersian"
elseif TextMsg == 'الانكليزيه' or TextMsg == 'الانكليزيه بالكتم' or TextMsg == 'الانكليزيه بالطرد' or TextMsg == 'الانكليزيه بالتقييد' or TextMsg == 'الانكليزيه بالتقيد' then
srt = "WordsEnglish"
elseif TextMsg == 'الدخول' or TextMsg == 'الدخول بالكتم' or TextMsg == 'الدخول بالطرد' or TextMsg == 'الدخول بالتقييد' or TextMsg == 'الدخول بالتقيد' then
srt = "JoinByLink"
elseif TextMsg == 'الاضافه' or TextMsg == 'الاضافه بالكتم' or TextMsg == 'الاضافه بالطرد' or TextMsg == 'الاضافه بالتقييد' or TextMsg == 'الاضافه بالتقيد' then
srt = "AddMempar"
elseif TextMsg == 'الملصقات' or TextMsg == 'الملصقات بالكتم' or TextMsg == 'الملصقات بالطرد' or TextMsg == 'الملصقات بالتقييد' or TextMsg == 'الملصقات بالتقيد' then
srt = "messageSticker"
elseif TextMsg == 'الاغاني' or TextMsg == 'الاغاني بالكتم' or TextMsg == 'الاغاني بالطرد' or TextMsg == 'الاغاني بالتقييد' or TextMsg == 'الاغاني بالتقيد' then
srt = "messageVoiceNote"
elseif TextMsg == 'الصوت' or TextMsg == 'الصوت بالكتم' or TextMsg == 'الصوت بالطرد' or TextMsg == 'الصوت بالتقييد' or TextMsg == 'الصوت بالتقيد' then
srt = "messageAudio"
elseif TextMsg == 'الملفات' or TextMsg == 'الملفات بالكتم' or TextMsg == 'الملفات بالطرد' or TextMsg == 'الملفات بالتقييد' or TextMsg == 'الملفات بالتقيد' then
srt = "messageDocument"
elseif TextMsg == 'المتحركات' or TextMsg == 'المتحركات بالكتم' or TextMsg == 'المتحركات بالطرد' or TextMsg == 'المتحركات بالتقييد' or TextMsg == 'المتحركات بالتقيد' then
srt = "messageDocument"
elseif TextMsg == 'المتحركه' or TextMsg == 'المتحركات بالكتم' or TextMsg == 'المتحركات بالطرد' or TextMsg == 'المتحركات بالتقييد' or TextMsg == 'المتحركات بالتقيد' then
srt = "messageAnimation"
elseif TextMsg == 'الرسائل' or TextMsg == 'الرسائل بالكتم' or TextMsg == 'الرسائل بالطرد' or TextMsg == 'الرسائل بالتقييد' or TextMsg == 'الرسائل بالتقيد' then
srt = "messageText"
elseif TextMsg == 'الدردشه' or TextMsg == 'الدردشه بالكتم' or TextMsg == 'الدردشه بالطرد' or TextMsg == 'الدردشه بالتقييد' or TextMsg == 'الدردشه بالتقيد' then
srt = "message"
elseif TextMsg == 'الاستفتاء' or TextMsg == 'الاستفتاء بالكتم' or TextMsg == 'الاستفتاء بالطرد' or TextMsg == 'الاستفتاء بالتقييد' or TextMsg == 'الاستفتاء بالتقيد' then
srt = "messagePoll"
elseif TextMsg == 'الموقع' or TextMsg == 'الموقع بالكتم' or TextMsg == 'الموقع بالطرد' or TextMsg == 'الموقع بالتقييد' or TextMsg == 'الموقع بالتقيد' then
srt = "messageLocation"
elseif TextMsg == 'الجهات' or TextMsg == 'الجهات بالكتم' or TextMsg == 'الجهات بالطرد' or TextMsg == 'الجهات بالتقييد' or TextMsg == 'الجهات بالتقيد' then
srt = "messageContact"
elseif TextMsg == 'السيلفي' or TextMsg == 'السيلفي بالكتم' or TextMsg == 'السيلفي بالطرد' or TextMsg == 'السيلفي بالتقييد' or TextMsg == 'السيلفي بالتقيد' or TextMsg == 'الفيديو نوت' or TextMsg == 'الفيديو نوت بالكتم' or TextMsg == 'الفيديو نوت بالطرد' or TextMsg == 'الفيديو نوت بالتقييد' or TextMsg == 'الفيديو نوت بالتقيد' then
srt = "messageVideoNote"
elseif TextMsg == 'التثبيت' or TextMsg == 'التثبيت بالكتم' or TextMsg == 'التثبيت بالطرد' or TextMsg == 'التثبيت بالتقييد' or TextMsg == 'التثبيت بالتقيد' then
srt = "messagePinMessage"
elseif TextMsg == 'القناه' or TextMsg == 'القناه بالكتم' or TextMsg == 'القناه بالطرد' or TextMsg == 'القناه بالتقييد' or TextMsg == 'القناه بالتقيد' then
srt = "messageSenderChat"
elseif TextMsg == 'الشارحه' or TextMsg == 'الشارحه بالكتم' or TextMsg == 'الشارحه بالطرد' or TextMsg == 'الشارحه بالتقييد' or TextMsg == 'الشارحه بالتقيد' then
srt = "Cmd"
elseif TextMsg == 'الاشعارات' or TextMsg == 'الاشعارات بالكتم' or TextMsg == 'الاشعارات بالطرد' or TextMsg == 'الاشعارات بالتقييد' or TextMsg == 'الاشعارات بالتقيد' then
srt = "Tagservr"
elseif TextMsg == 'المعرفات' or TextMsg == 'المعرفات بالكتم' or TextMsg == 'المعرفات بالطرد' or TextMsg == 'المعرفات بالتقييد' or TextMsg == 'المعرفات بالتقيد' then
srt = "Username"
elseif TextMsg == 'الكيبورد' or TextMsg == 'الكيبورد بالكتم' or TextMsg == 'الكيبورد بالطرد' or TextMsg == 'الكيبورد بالتقييد' or TextMsg == 'الكيبورد بالتقيد' then
srt = "Keyboard"
elseif TextMsg == 'الماركداون' or TextMsg == 'الماركداون بالكتم' or TextMsg == 'الماركداون بالطرد' or TextMsg == 'الماركداون بالتقييد' or TextMsg == 'الماركداون بالتقيد' then
srt = "Markdaun"
elseif TextMsg == 'الفشار' or TextMsg == 'الفشار بالكتم' or TextMsg == 'الفشار بالطرد' or TextMsg == 'الفشار بالتقييد' or TextMsg == 'الفشار بالتقيد' then
srt = "WordsFshar"
elseif TextMsg == 'التشويش' or TextMsg == 'التشويش بالكتم' or TextMsg == 'التشويش بالطرد' or TextMsg == 'التشويش بالتقييد' or TextMsg == 'التشويش بالتقيد' then
srt = "TerowerKPs"
elseif TextMsg == 'البريميوم' or TextMsg == 'البريميوم بالكتم' or TextMsg == 'البريميوم بالطرد' or TextMsg == 'البريميوم بالتقييد' or TextMsg == 'البريميوم بالتقيد' then
srt = "ErdewnGu"
elseif TextMsg == 'الكلايش' or TextMsg == 'الكلايش بالكتم' or TextMsg == 'الكلايش بالطرد' or TextMsg == 'الكلايش بالتقييد' or TextMsg == 'الكلايش بالتقيد' then
srt = "Spam"
elseif TextMsg == 'البوتات' or TextMsg == 'البوتات بالكتم' or TextMsg == 'البوتات بالطرد' or TextMsg == 'البوتات بالتقييد' or TextMsg == 'البوتات بالتقيد' then
srt = "messageChatAddMembers"
elseif TextMsg == 'التوجيه' or TextMsg == 'التوجيه بالكتم' or TextMsg == 'التوجيه بالطرد' or TextMsg == 'التوجيه بالتقييد' or TextMsg == 'التوجيه بالتقيد' then
srt = "forward_info"
elseif TextMsg == 'الروابط' or TextMsg == 'الروابط بالكتم' or TextMsg == 'الروابط بالطرد' or TextMsg == 'الروابط بالتقييد' or TextMsg == 'الروابط بالتقيد' then
srt = "Links"
elseif TextMsg == 'التعديل' or TextMsg == 'التعديل بالكتم' or TextMsg == 'التعديل بالطرد' or TextMsg == 'التعديل بالتقييد' or TextMsg == 'التعديل بالتقيد' or TextMsg == 'تعديل الميديا' or TextMsg == 'تعديل الميديا بالكتم' or TextMsg == 'تعديل الميديا بالطرد' or TextMsg == 'تعديل الميديا بالتقييد' or TextMsg == 'تعديل الميديا بالتقيد' then
srt = "Edited"
elseif TextMsg == 'التاك' or TextMsg == 'تاك بالكتم' or TextMsg == 'تاك بالطرد' or TextMsg == 'تاك بالتقييد' or TextMsg == 'تاك بالتقيد' then
srt = "Hashtak"
elseif TextMsg == 'الهمسه' or TextMsg == 'الهمسه بالكتم' or TextMsg == 'الهمسه بالطرد' or TextMsg == 'الهمسه بالتقييد' or TextMsg == 'الهمسه بالتقيد' then
srt = "via_bot_user_id"
elseif TextMsg == 'الانلاين' or TextMsg == 'الانلاين بالكتم' or TextMsg == 'الانلاين بالطرد' or TextMsg == 'الانلاين بالتقييد' or TextMsg == 'الانلاين بالتقيد' then
srt = "via_bot_user_id"
else
return false
end  
if redis:get(bot_id..":"..msg.chat_id..":settings:"..srt) == setTyp then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu,"md",true)  
else
redis:set(bot_id..":"..msg.chat_id..":settings:"..srt,setTyp)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by,"md",true)  
end
end
end
if text and text:match("^فتح (.*)$") and tonumber(msg.reply_to_message_id) == 0 then
local TextMsg = text:match("^فتح (.*)$")
local TextMsg = text:match("^فتح (.*)$")
if msg.content.text then 
if TextMsg == 'الصور' then
srt = "messagePhoto"
elseif TextMsg == 'الفيديو' then
srt = "messageVideo "
elseif TextMsg == 'الفارسيه' or TextMsg == 'الفارسية' or TextMsg == 'الفارسي' then
srt = "WordsPersian"
elseif TextMsg == 'الانكليزيه' or TextMsg == 'الانكليزية' or TextMsg == 'الانكليزي' then
srt = "WordsEnglish"
elseif TextMsg == 'الدخول' then
srt = "JoinByLink"
elseif TextMsg == 'الاضافه' then
srt = "AddMempar"
elseif TextMsg == 'الملصقات' then
srt = "messageSticker"
elseif TextMsg == 'الاغاني' then
srt = "messageVoiceNote"
elseif TextMsg == 'الصوت' then
srt = "messageAudio"
elseif TextMsg == 'الملفات' then
srt = "messageDocument "
elseif TextMsg == 'المتحركات' then
srt = "messageDocument "
elseif TextMsg == 'المتحركه' then
srt = "messageAnimation"
elseif TextMsg == 'الرسائل' then
srt = "messageText"
elseif TextMsg == 'التثبيت' then
srt = "messagePinMessage"
elseif TextMsg == 'الدردشه' then
srt = "message"
elseif TextMsg == 'التوجيه' and BasicConstructor(msg) then
srt = "forward_info"
elseif TextMsg == 'الاستفتاء' then
srt = "messagePoll"
elseif TextMsg == 'الموقع' then
srt = "messageLocation"
elseif TextMsg == 'الجهات' and BasicConstructor(msg) then
srt = "messageContact"
elseif TextMsg == 'السيلفي' or TextMsg == 'الفيديو نوت' then
srt = "messageVideoNote"
elseif TextMsg == 'القناه' and BasicConstructor(msg) then
srt = "messageSenderChat"
elseif TextMsg == 'الشارحه' then
srt = "Cmd"
elseif TextMsg == 'الاشعارات' then
srt = "Tagservr"
elseif TextMsg == 'المعرفات' then
srt = "Username"
elseif TextMsg == 'الكيبورد' then
srt = "Keyboard"
elseif TextMsg == 'الكلايش' then
srt = "Spam"
elseif TextMsg == 'الماركداون' then
srt = "Markdaun"
elseif TextMsg == 'الفشار' then
srt = "WordsFshar"
elseif TextMsg == 'التشويش' then
srt = "TerowerKPs"
elseif TextMsg == 'البريميوم' then
srt = "ErdewnGu"
elseif TextMsg == 'البوتات' and BasicConstructor(msg) then
srt = "messageChatAddMembers"
elseif TextMsg == 'الرابط' or TextMsg == 'الروابط' then
srt = "Links"
elseif TextMsg == 'التعديل' and BasicConstructor(msg) then
srt = "Edited"
elseif TextMsg == 'التاك' or TextMsg == 'هشتاك' then
srt = "Hashtak"
elseif TextMsg == 'الهمسه' then
srt = "via_bot_user_id"
elseif TextMsg == 'الانلاين' or TextMsg == 'الاين' or TextMsg == 'انلاين' then
srt = "via_bot_user_id"
else
return false
end  
if not redis:get(bot_id..":"..msg.chat_id..":settings:"..srt) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu,"md",true)  
else
redis:del(bot_id..":"..msg.chat_id..":settings:"..srt)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by,"md",true)  
end
end
end
end
----------------------------------------------------------------------------------------------------
if text == "اطردني" or text == "طردني" then
if redis:get(bot_id..":"..msg.chat_id..":settings:kickme") then
return bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم تعطيل اطردني من قبل المدراء .*","md",true)  
end
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اضغط نعم لتأكيد طردك *","md", true, false, false, false, bot.replyMarkup{
type = 'inline',data = {{{text = '‹ نعم ›',data="Sur_"..msg.sender_id.user_id.."_1"},{text = '‹ الغاء ›',data="Sur_"..msg.sender_id.user_id.."_2"}},}})
end
if text == 'الالعاب' or text == 'قائمه الالعاب' or text == 'قائمة الالعاب' or text == 'العاب' then
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
t = "*⤈︙ قائمه العاب سورس تريكس .\nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⤈︙ لعبة حجرة ورقة مقص - حجره .\n⤈︙ لعبة الرياضه - رياضه .\n⤈︙ لعبة معرفة الصورة - صور .\n⤈︙ لعبة معرفة الموسيقى - موسيقى .\n⤈︙ لعبة المشاهير - مشاهير .\n⤈︙ لعبة العكس - العكس .\n⤈︙ لعبة الحزوره - حزوره .\n⤈︙ لعبة المعاني - معاني .\n⤈︙ لعبة البات - بات .\n⤈︙ لعبة التخمين - خمن .\n⤈︙ لعبه الاسرع - الاسرع .\n⤈︙ لعبه الترجمه - انكليزي .\n⤈︙ لعبه تفكيك الكلمه - تفكيك .\n⤈︙ لعبه تركيب الكلمه - تركيب .\n⤈︙ لعبه الرياضيات - رياضيات .\n⤈︙ لعبة السمايلات - سمايلات .\n⤈︙ لعبة العواصم - العواصم .\n⤈︙ لعبة الارقام - ارقام .\n⤈︙ لعبة الحروف - حروف .\n⤈︙ كت تويت - كت .\n⤈︙ لعبة الاعلام والدول - اعلام .\n⤈︙ لعبة الصراحه - صراحه .\n⤈︙ لعبة الروليت - روليت .\n⤈︙ لعبة احكام - احكام .\n⤈︙ لعبة العقاب - عقاب .\n⤈︙ لعبة الكلمات - كلمات .\nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ \n⤈︙ نقاطي - لعرض عدد نقاطك .\n⤈︙ بيع نقاطي + العدد لبيع كل نقطه مقابل 50 رساله .*"
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).yu,"md", true, false, false, false, reply_markup)
end
if text == 'اوامر التسليه' or text == 'التسليه' or text == 'قائمه التسليه' or text == 'تسليه' then
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اوامر التسليه معطله بواسطه المشرفين .","md",true)
end
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
t = "⤈︙ قائمه اوامر التسليه .\nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ \n⤈︙ بوسه .\n⤈︙ مصه .\n⤈︙ كت . \n⤈︙ رزله . \n⤈︙ هينه .\n⤈︙ شنو رئيك بهذا .\n⤈︙ شنو رئيك بهاي .\n⤈︙ زواج .\n⤈︙ طلاق .\n⤈︙ تاكات .\n⤈︙ الابراج ، حساب عمر ،  زخرفه .\n⤈︙ اهداء .\n⤈︙ غنيلي .\n⤈︙ ريمكس .\n⤈︙ شعر .\n⤈︙ ميمز .\n⤈︙ تحدي .\n⤈︙ زوجني .\n⤈︙ نسبه الحب .\n⤈︙ نسبه الكره .\n⤈︙ نسبه الغباء .\n⤈︙ نسبه الذكاء .\n⤈︙ نسبه الرجوله .\n⤈︙ نسبه الانوثه .\n⤈︙ ترند .\n⤈︙ جمالي .\n⤈︙ رفع كلب .\n⤈︙ رفع بقره .\n⤈︙ رفع غبي .\n⤈︙ رفع زق ."
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).yu,"md", true, false, false, false, reply_markup)
end
if text == 'اوامر النسب' or text == 'النسب' or text == 'قائمه اوامر النسب' then
if not redis:get(bot_id.."nsab"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اوامر النسب معطله بواسطه المشرفين .","md",true)
end
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
t = "⤈︙ قائمه اوامر النسب .\nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ \n⤈︙ نسبه الحب .\n⤈︙ نسبه الكره .\n⤈︙ نسبه الغباء . \n⤈︙ نسبه الرجوله . \n⤈︙ نسبه الانوثه .\n⤈︙ نسبه جمالي .\n⤈︙ نسبه اخلاقي .\n⤈︙ نسبه اخلاقه ."
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).yu,"md", true, false, false, false, reply_markup)
end
if not Bot(msg) then
if text == 'المشاركين' and redis:get(bot_id..":Witting_StartGame:"..msg.chat_id..msg.sender_id.user_id) then
local list = redis:smembers(bot_id..':List_Rolet:'..msg.chat_id) 
local Text = '\n  *ٴ─━─━─━─❌️─━─━─━─ *\n'
if #list == 0 then 
bot.sendText(msg.chat_id,msg.id,"*⤈︙ لا يوجد لاعبين*","md",true)
return false
end  
for k, v in pairs(list) do 
Text = Text..k.."-  [" ..v.."] .\n"  
end 
return bot.sendText(msg.chat_id,msg.id,Text,"md",true)  
end
if text == 'نعم' and redis:get(bot_id..":Witting_StartGame:"..msg.chat_id..msg.sender_id.user_id) then
local list = redis:smembers(bot_id..':List_Rolet:'..msg.chat_id) 
if #list == 1 then 
bot.sendText(msg.chat_id,msg.id,"⤈︙ لم يكتمل العدد الكلي للاعبين*","md",true)  
elseif #list == 0 then 
bot.sendText(msg.chat_id,msg.id,"*⤈︙ لم تقوم باضافه اي لاعب*","md",true)  
return false
end 
local UserName = list[math.random(#list)]
local User_ = UserName:match("^@(.*)$")
local UserId_Info = bot.searchPublicChat(User_)
if (UserId_Info.id) then
redis:incrby(bot_id..":"..msg.chat_id..":"..UserId_Info.id..":game", 3)  
redis:del(bot_id..':List_Rolet:'..msg.chat_id) 
redis:del(bot_id..":Witting_StartGame:"..msg.chat_id..msg.sender_id.user_id)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ مبروك * ["..UserName.."] *لقد فزت\n⤈︙ تم اضافه 3 نقاط لك\n","md",true)  
return false
end
end
if text and text:match('^(@[%a%d_]+)$') and redis:get(bot_id..":Number_Add:"..msg.chat_id..msg.sender_id.user_id) then
if redis:sismember(bot_id..':List_Rolet:'..msg.chat_id,text) then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ المعرف* ["..text.." ] *موجود سابقا ارسل معرف لم يشارك*","md",true)  
return false
end 
redis:sadd(bot_id..':List_Rolet:'..msg.chat_id,text)
local CountAdd = redis:get(bot_id..":Number_Add:"..msg.chat_id..msg.sender_id.user_id)
local CountAll = redis:scard(bot_id..':List_Rolet:'..msg.chat_id)
local CountUser = CountAdd - CountAll
if tonumber(CountAll) == tonumber(CountAdd) then 
redis:del(bot_id..":Number_Add:"..msg.chat_id..msg.sender_id.user_id) 
redis:setex(bot_id..":Witting_StartGame:"..msg.chat_id..msg.sender_id.user_id,1400,true)  
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم حفظ المعرف (*["..text.."]*)\n⤈︙ ارسل ( نعم ) للبدء*","md",true)  
return false
end  
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم حفظ المعرف* (["..text.."])\n*⤈︙ تبقى "..CountUser.." لاعبين ليكتمل العدد\n⤈︙ ارسل المعرف التالي*","md",true)  
return false
end 
if text and text:match("^(%d+)$") and redis:get(bot_id..":Start_Rolet:"..msg.chat_id..msg.sender_id.user_id) then
if text == "1" then
bot.sendText(msg.chat_id,msg.id," *⤈︙ لا استطيع بدء اللعبه بلاعب واحد فقط*","md",true)
elseif text ~= "1" then
redis:set(bot_id..":Number_Add:"..msg.chat_id..msg.sender_id.user_id,text)  
redis:del(bot_id..":Start_Rolet:"..msg.chat_id..msg.sender_id.user_id)  
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسل معرفات اللاعبين الان*","md",true)
return false
end
end
if redis:get(bot_id.."Game:Smile"..msg.chat_id) then
if text == redis:get(bot_id.."Game:Smile"..msg.chat_id) then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game", 1)  
redis:del(bot_id.."Game:Smile"..msg.chat_id)
ballancee = redis:get(bot_id.."boob"..msg.sender_id.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender_id.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ كفو اجابتك صح \n⤈︙ تم اضافة لك نقطة\n⤈︙ نقاطك الان : "..Num.." \n","md",true)
end
end 

if redis:get(bot_id.."GAME:S"..msg.chat_id) then
if text == redis:get(bot_id.."GAME:CHER"..msg.chat_id) then
redis:del(bot_id.."GAME:S"..msg.chat_id)
redis:del(bot_id.."GAME:CHER"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game", 1)  
ballancee = redis:get(bot_id.."boob"..msg.sender_id.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender_id.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ كفو اجابتك صح \n⤈︙ تم اضافة لك نقطة\n⤈︙ نقاطك الان : "..Num.." \n","md",true)
end
end 

if redis:get(bot_id.."Game:Monotonous"..msg.chat_id) then
if text == redis:get(bot_id.."Game:Monotonous"..msg.chat_id) then
redis:del(bot_id.."Game:Monotonous"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game", 1)  
ballancee = redis:get(bot_id.."boob"..msg.sender_id.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender_id.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ كفو اجابتك صح \n⤈︙ تم اضافة لك نقطة\n⤈︙ نقاطك الان : "..Num.."\n ","md",true)
end
end 
if redis:get(bot_id.."Game:Riddles"..msg.chat_id) then
if text == redis:get(bot_id.."Game:Riddles"..msg.chat_id) then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game", 1)  
ballancee = redis:get(bot_id.."boob"..msg.sender_id.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender_id.user_id , gampoin)
redis:del(bot_id.."Game:Riddles"..msg.chat_id)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ كفو اجابتك صح \n⤈︙ تم اضافة لك نقطة\n⤈︙ نقاطك الان : "..Num.." \n","md",true)
end
end
if redis:get(bot_id.."Game:Meaningof"..msg.chat_id) then
if text == redis:get(bot_id.."Game:Meaningof"..msg.chat_id) then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game", 1)  
ballancee = redis:get(bot_id.."boob"..msg.sender_id.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender_id.user_id , gampoin)
redis:del(bot_id.."Game:Meaningof"..msg.chat_id)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ كفو اجابتك صح \n⤈︙ تم اضافة لك نقطة\n⤈︙ نقاطك الان : "..Num.." \n","md",true)
end
end
if redis:get(bot_id.."Game:Reflection"..msg.chat_id) then
if text == redis:get(bot_id.."Game:Reflection"..msg.chat_id) then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game", 1)  
redis:del(bot_id.."Game:Reflection"..msg.chat_id)
ballancee = redis:get(bot_id.."boob"..msg.sender_id.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender_id.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ كفو اجابتك صح \n⤈︙ تم اضافة لك نقطة\n⤈︙ نقاطك الان : "..Num.."\n ","md",true)
end
end

if redis:get(bot_id.."Game:Example"..msg.chat_id) then
if text == redis:get(bot_id.."Game:Example"..msg.chat_id) then 
redis:del(bot_id.."Game:Example"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game", 1)  
ballancee = redis:get(bot_id.."boob"..msg.sender_id.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender_id.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ كفو اجابتك صح \n⤈︙ تم اضافة لك نقطة\n⤈︙ نقاطك الان : "..Num.."\n ","md",true)
end
end

if redis:get(bot_id..'Games:Set:Answer'..msg.chat_id) then
if text == ""..(redis:get(bot_id..'Games:Set:Answer'..msg.chat_id) or '66765$47').."" then 
redis:del(bot_id.."Games:Set:Answer"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game", 5)  
ballancee = redis:get(bot_id.."boob"..msg.sender_id.user_id) or 0
gampoin = ballancee + 5
redis:set(bot_id.."boob"..msg.sender_id.user_id , gampoin)
redis:del(bot_id.."Games:Set:Answer"..msg.chat_id)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ كفو اجابتك صح \n⤈︙ تم اضافة لك 5 نقاط\n⤈︙ نقاطك الان : "..Num.." \n","md",true)
end
end

if redis:get(bot_id.."Start_rhan"..msg.chat_id) then
if text and text:match('^انا (.*)$') then
local UserName = text:match('^انا (.*)$')
local coniss = coin(UserName)
ballancee = redis:get(bot_id.."boob"..msg.sender_id.user_id) or 0
if tonumber(coniss) < 999 then
return bot.sendText(msg.chat_id,msg.id, "⤈︙  الحد الادنى المسموح هو 1000 دينار 💵\n","md",true)
end
if tonumber(ballancee) < tonumber(coniss) then
return bot.sendText(msg.chat_id,msg.id, "⤈︙  فلوسك ماتكفي \n","md",true)
end
if redis:sismember(bot_id..'List_rhan'..msg.chat_id,msg.sender_id.user_id) then
return bot.sendText(msg.chat_id,msg.id,'⤈︙ انت مضاف من قبل .',"md",true)
end
redis:set(bot_id.."playerrhan"..msg.chat_id,msg.sender_id.user_id)
redis:set(bot_id.."playercoins"..msg.chat_id..msg.sender_id.user_id,coniss)
redis:sadd(bot_id..'List_rhan'..msg.chat_id,msg.sender_id.user_id)
redis:setex(bot_id.."Witting_Startrhan"..msg.chat_id,1400,true)
benrahan = redis:get(bot_id.."allrhan"..msg.chat_id..12345) or 0
rehan = tonumber(benrahan) + tonumber(coniss)
redis:set(bot_id.."allrhan"..msg.chat_id..12345 , rehan)
local ballancee = redis:get(bot_id.."boob"..msg.sender_id.user_id) or 0
rehan = tonumber(ballancee) - tonumber(coniss)
redis:set(bot_id.."boob"..msg.sender_id.user_id , rehan)
return bot.sendText(msg.chat_id,msg.id,'⤈︙ تم ضفتك للرهان \n⤈︙ للانتهاء يرسل ( نعم ) اللي بدء الرهان .',"md",true)
end
end

if redis:get(bot_id.."Start_Ahkam"..msg.chat_id) then
if text == "انا" then
if redis:sismember(bot_id..'List_Ahkam'..msg.chat_id,msg.sender_id.user_id) then
return bot.sendText(msg.chat_id,msg.id,'⤈︙ انت مضاف من قبل .',"md",true)
end
redis:sadd(bot_id..'List_Ahkam'..msg.chat_id,msg.sender_id.user_id)
redis:setex(bot_id.."Witting_StartGameh"..msg.chat_id,1400,true)
return bot.sendText(msg.chat_id,msg.id,'⤈︙ تم ضفتك للعبة \n⤈︙ للانتهاء يرسل نعم اللي بدء اللعبة .',"md",true)
end
end

if redis:get(bot_id.."Start_Ahkamm"..msg.chat_id) then
if text == "انا" then
if redis:sismember(bot_id..'List_Ahkamm'..msg.chat_id,msg.sender_id.user_id) then
return bot.sendText(msg.chat_id,msg.id,'⤈︙ انت مضاف من قبل .',"md",true)
end
redis:sadd(bot_id..'List_Ahkamm'..msg.chat_id,msg.sender_id.user_id)
redis:setex(bot_id.."Witting_StartGamehh"..msg.chat_id,1400,true)
return bot.sendText(msg.chat_id,msg.id,'⤈︙ تم ضفتك للعبة \n⤈︙ للانتهاء يرسل نعم اللي بدء اللعبة .',"md",true)
end
end

if redis:get(bot_id.."Set_fkk"..msg.chat_id) then
if text == redis:get(bot_id.."Set_fkk"..msg.chat_id) then
redis:del(bot_id.."Set_fkk"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game", 1)  
ballancee = redis:get(bot_id.."boob"..msg.sender_id.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender_id.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ كفو اجابتك صح \n⤈︙ تم اضافة لك نقطة\n⤈︙ نقاطك الان : "..Num.." \n","md",true)
end
end 

if redis:get(bot_id.."Set_trkib"..msg.chat_id) then
if text == redis:get(bot_id.."Set_trkib"..msg.chat_id) then
redis:del(bot_id.."Set_trkib"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game", 1)  
ballancee = redis:get(bot_id.."boob"..msg.sender_id.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender_id.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ كفو اجابتك صح \n⤈︙ تم اضافة لك نقطة\n⤈︙ نقاطك الان : "..Num.."\n ","md",true)
end
end

if redis:get(bot_id.."Game:arkkamm"..msg.chat_id) then
if text == redis:get(bot_id.."Game:arkkamm"..msg.chat_id) then
redis:del(bot_id.."Game:arkkamm"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game", 1)  
ballancee = redis:get(bot_id.."boob"..msg.sender_id.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender_id.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ كفو اجابتك صح \n⤈︙ تم اضافة لك نقطة\n⤈︙ نقاطك الان : "..Num.."\n ","md",true)
end
end

if redis:get(bot_id.."Game:aoismm"..msg.chat_id) then
if text == redis:get(bot_id.."Game:aoismm"..msg.chat_id) then
redis:del(bot_id.."Game:aoismm"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game", 1)  
ballancee = redis:get(bot_id.."boob"..msg.sender_id.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender_id.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ كفو اجابتك صح \n⤈︙ تم اضافة لك نقطة\n⤈︙ نقاطك الان : "..Num.."\n ","md",true)
end
end 

if redis:get(bot_id.."Game:Kokoo"..msg.chat_id) then
if text == redis:get(bot_id.."Game:Kokoo"..msg.chat_id) then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game", 1)  
redis:del(bot_id.."Game:Kokoo"..msg.chat_id)
ballancee = redis:get(bot_id.."boob"..msg.sender_id.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender_id.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ كفو اجابتك صح \n⤈︙ تم اضافة لك نقطة\n⤈︙ نقاطك الان : "..Num.." \n","md",true)
end
end

if redis:get(bot_id.."Game:Countrygof"..msg.chat_id) then
if text == redis:get(bot_id.."Game:Countrygof"..msg.chat_id) then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game", 1)  
redis:del(bot_id.."Game:Countrygof"..msg.chat_id)
ballancee = redis:get(bot_id.."boob"..msg.sender_id.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender_id.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ كفو اجابتك صح \n⤈︙ تم اضافة لك نقطة\n⤈︙ نقاطك الان : "..Num.." \n","md",true)
end
end


if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game:Estimate") then  
if text and text:match("^(%d+)$") then
local NUM = text:match("^(%d+)$")
if tonumber(NUM) > 20 then
return bot.sendText(msg.chat_id,msg.id,"*⤈︙ يجب ان لا يكون الرقم المخمن اكبر من ( 20 )\n⤈︙ خمن رقم بين ( 1 و 20 )*","md",true)  
end 
local GETNUM = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game:Estimate")
if tonumber(NUM) == tonumber(GETNUM) then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game:SADD")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game:Estimate")
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game",5)  
return bot.sendText(msg.chat_id,msg.id,"*⤈︙ خمنت الرقم صح\n⤈︙ تم اضافة ( 5 ) نقاط لك*\n","md",true)
elseif tonumber(NUM) ~= tonumber(GETNUM) then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game:SADD",1)
if tonumber(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game:SADD")) >= 3 then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game:SADD")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game:Estimate")
return bot.sendText(msg.chat_id,msg.id,"*⤈︙ خسرت في اللعبه\n⤈︙ كان الرقم الذي تم تخمينه ( "..GETNUM.." )*","md",true)  
else
return bot.sendText(msg.chat_id,msg.id,"* ⤈︙ تخمينك خطأ\n ارسل رقم من جديد *","md",true)  
end
end
end
end
end

if text == 'الروليت' or text == 'روليت' then
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
redis:del(bot_id..":Number_Add:"..msg.chat_id..msg.sender_id.user_id) 
redis:del(bot_id..':List_Rolet:'..msg.chat_id)  
redis:setex(bot_id..":Start_Rolet:"..msg.chat_id..msg.sender_id.user_id,3600,true)  
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسل عدد اللاعبين للروليت*","md",true)  
end

if text == "حروف" or text == "حرف" or text == "الحروف" then
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
local texting = {" جماد بحرف ↫ ر  ", 
" مدينة بحرف ↫ ع  ",
" حيوان ونبات بحرف ↫ خ  ", 
" اسم بحرف ↫ ح  ", 
" اسم ونبات بحرف ↫ م  ", 
" دولة عربية بحرف ↫ ق  ", 
" جماد بحرف ↫ ي  ", 
" نبات بحرف ↫ ج  ", 
" اسم بنت بحرف ↫ ع  ", 
" اسم ولد بحرف ↫ ع  ", 
" اسم بنت وولد بحرف ↫ ث  ", 
" جماد بحرف ↫ ج  ",
" حيوان بحرف ↫ ص  ",
" دولة بحرف ↫ س  ",
" نبات بحرف ↫ ج  ",
" مدينة بحرف ↫ ب  ",
" نبات بحرف ↫ ر  ",
" اسم بحرف ↫ ك  ",
" حيوان بحرف ↫ ظ  ",
" جماد بحرف ↫ ذ  ",
" مدينة بحرف ↫ و  ",
" اسم بحرف ↫ م  ",
" اسم بنت بحرف ↫ خ  ",
" اسم و نبات بحرف ↫ ر  ",
" نبات بحرف ↫ و  ",
" حيوان بحرف ↫ س  ",
" مدينة بحرف ↫ ك  ",
" اسم بنت بحرف ↫ ص  ",
" اسم ولد بحرف ↫ ق  ",
" نبات بحرف ↫ ز  ",
"  جماد بحرف ↫ ز  ",
"  مدينة بحرف ↫ ط  ",
"  جماد بحرف ↫ ن  ",
"  مدينة بحرف ↫ ف  ",
"  حيوان بحرف ↫ ض  ",
"  اسم بحرف ↫ ك  ",
"  نبات و حيوان و مدينة بحرف ↫ س  ", 
"  اسم بنت بحرف ↫ ج  ", 
"  مدينة بحرف ↫ ت  ", 
"  جماد بحرف ↫ ه  ", 
"  اسم بنت بحرف ↫ ر  ", 
" اسم ولد بحرف ↫ خ  ", 
" جماد بحرف ↫ ع  ",
" حيوان بحرف ↫ ح  ",
" نبات بحرف ↫ ف  ",
" اسم بنت بحرف ↫ غ  ",
" اسم ولد بحرف ↫ و  ",
" نبات بحرف ↫ ل  ",
"مدينة بحرف ↫ ع  ",
"دولة واسم بحرف ↫ ب  ",
} 
return bot.sendText(msg.chat_id,msg.id,texting[math.random(#texting)],'md')
end

if text == "سمايلات" or text == "سمايل" then
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
Random = {"🍏","🍎","🍐","??","🍋","🍉","??","🍓","🍈","🍒","🍑","🍍","🥥","🥝","🍅","🍆","🥑","🥦","🥒","🌶","🌽","🥕","🥔","🥖","🥐","🍞","🥨","🍟","??","🥚","🍳","🥓","🥩","🍗","🍖","🌭","🍔","🍠","🍕","🥪","🥙","☕️","🥤","🍶","🍺","🍻","🏀","⚽️","🏈","⚾️","🎾","🏐","🏉","🎱","🏓","🏸","🥅","🎰","🎮","🎳","🎯","??","🎻","🎸","🎺","??","🎹","??","🎧","🎤","🎬","🎨","🎭","🎪","🎟","🎫","🎗","🏵","🎖","??","🥌","🛷","🚗","🚌","🏎","🚓","🚑","🚚","🚛","🚜","⚔","🛡","🔮","🌡","💣","⤈︙","📍","📓","📗","📂","📅","📪","??","⤈︙","📭","⏰","??","🎚","☎️","📡"}
SM = Random[math.random(#Random)]
redis:set(bot_id.."Game:Smile"..msg.chat_id,SM)
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اسرع واحد يرسل هذا السمايل ? ~ (`"..SM.."`)","md",true)  
end

if text == "الاسرع" or text == "ترتيب" then
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
KlamSpeed = {"سحور","سياره","استقبال","قنفه","ايفون","بزونه","مطبخ","كرستيانو","دجاجه","مدرسه","الوان","غرفه","ثلاجه","كهوه","سفينه","العراق","محطه","طياره","رادار","منزل","مستشفى","كهرباء","تفاحه","اخطبوط","سلمون","فرنسا","برتقاله","تفاح","مطرقه","بتيته","لهانه","شباك","باص","سمكه","ذباب","تلفاز","حاسوب","انترنيت","ساحه","جسر"};
name = KlamSpeed[math.random(#KlamSpeed)]
redis:set(bot_id.."Game:Monotonous"..msg.chat_id,name)
name = string.gsub(name,"سحور","س ر و ح")
name = string.gsub(name,"سياره","ه ر س ي ا")
name = string.gsub(name,"استقبال","ل ب ا ت ق س ا")
name = string.gsub(name,"قنفه","ه ق ن ف")
name = string.gsub(name,"ايفون","و ن ف ا")
name = string.gsub(name,"بزونه","ز و ه ن")
name = string.gsub(name,"مطبخ","خ ب ط م")
name = string.gsub(name,"كرستيانو","س ت ا ن و ك ر ي")
name = string.gsub(name,"دجاجه","ج ج ا د ه")
name = string.gsub(name,"مدرسه","ه م د ر س")
name = string.gsub(name,"الوان","ن ا و ا ل")
name = string.gsub(name,"غرفه","غ ه ر ف")
name = string.gsub(name,"ثلاجه","ج ه ت ل ا")
name = string.gsub(name,"كهوه","ه ك ه و")
name = string.gsub(name,"سفينه","ه ن ف ي س")
name = string.gsub(name,"العراق","ق ع ا ل ر ا")
name = string.gsub(name,"محطه","ه ط م ح")
name = string.gsub(name,"طياره","ر ا ط ي ه")
name = string.gsub(name,"رادار","ر ا ر ا د")
name = string.gsub(name,"منزل","ن ز م ل")
name = string.gsub(name,"مستشفى","ى ش س ف ت م")
name = string.gsub(name,"كهرباء","ر ب ك ه ا ء")
name = string.gsub(name,"تفاحه","ح ه ا ت ف")
name = string.gsub(name,"اخطبوط","ط ب و ا خ ط")
name = string.gsub(name,"سلمون","ن م و ل س")
name = string.gsub(name,"فرنسا","ن ف ر س ا")
name = string.gsub(name,"برتقاله","ر ت ق ب ا ه ل")
name = string.gsub(name,"تفاح","ح ف ا ت")
name = string.gsub(name,"مطرقه","ه ط م ر ق")
name = string.gsub(name,"بتيته","ب ت ت ي ه")
name = string.gsub(name,"لهانه","ه ن ل ه ل")
name = string.gsub(name,"شباك","ب ش ا ك")
name = string.gsub(name,"باص","ص ا ب")
name = string.gsub(name,"سمكه","ك س م ه")
name = string.gsub(name,"ذباب","ب ا ب ذ")
name = string.gsub(name,"تلفاز","ت ف ل ز ا")
name = string.gsub(name,"حاسوب","س ا ح و ب")
name = string.gsub(name,"انترنيت","ا ت ن ر ن ي ت")
name = string.gsub(name,"ساحه","ح ا ه س")
name = string.gsub(name,"جسر","ر ج س")
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اسرع واحد يرتبها ~ ( "..name.." )","md",true)  
end
if text == "حزوره" then
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
Hzora = {"الجرس","عقرب الساعه","السمك","المطر","5","الكتاب","البسمار","7","الكعبه","بيت الشعر","لهانه","انا","امي","الابره","الساعه","22","غلط","كم الساعه","البيتنجان","البيض","المرايه","الضوء","الهواء","الضل","العمر","القلم","المشط","الحفره","البحر","الثلج","الاسفنج","الصوت","بلم"};
name = Hzora[math.random(#Hzora)]
redis:set(bot_id.."Game:Riddles"..msg.chat_id,name)
name = string.gsub(name,"الجرس","شيئ اذا لمسته صرخ ما هوه ؟")
name = string.gsub(name,"عقرب الساعه","اخوان لا يستطيعان تمضيه اكثر من دقيقه معا فما هما ؟")
name = string.gsub(name,"السمك","ما هو الحيوان الذي لم يصعد الى سفينة نوح عليه السلام ؟")
name = string.gsub(name,"المطر","شيئ يسقط على رأسك من الاعلى ولا يجرحك فما هو ؟")
name = string.gsub(name,"5","ما العدد الذي اذا ضربته بنفسه واضفت عليه 5 يصبح ثلاثين ")
name = string.gsub(name,"الكتاب","ما الشيئ الذي له اوراق وليس له جذور ؟")
name = string.gsub(name,"البسمار","ما هو الشيئ الذي لا يمشي الا بالضرب ؟")
name = string.gsub(name,"7","عائله مؤلفه من 6 بنات واخ لكل منهن .فكم عدد افراد العائله ")
name = string.gsub(name,"الكعبه","ما هو الشيئ الموجود وسط مكة ؟")
name = string.gsub(name,"بيت الشعر","ما هو البيت الذي ليس فيه ابواب ولا نوافذ ؟ ")
name = string.gsub(name,"لهانه","وحده حلوه ومغروره تلبس مية تنوره .من هيه ؟ ")
name = string.gsub(name,"انا","ابن امك وابن ابيك وليس باختك ولا باخيك فمن يكون ؟")
name = string.gsub(name,"امي","اخت خالك وليست خالتك من تكون ؟ ")
name = string.gsub(name,"الابره","ما هو الشيئ الذي كلما خطا خطوه فقد شيئا من ذيله ؟ ")
name = string.gsub(name,"الساعه","ما هو الشيئ الذي يقول الصدق ولكنه اذا جاع كذب ؟")
name = string.gsub(name,"22","كم مره ينطبق عقربا الساعه على بعضهما في اليوم الواحد ")
name = string.gsub(name,"غلط","ما هي الكلمه الوحيده التي تلفض غلط دائما ؟ ")
name = string.gsub(name,"كم الساعه","ما هو السؤال الذي تختلف اجابته دائما ؟")
name = string.gsub(name,"البيتنجان","جسم اسود وقلب ابيض وراس اخظر فما هو ؟")
name = string.gsub(name,"البيض","ماهو الشيئ الذي اسمه على لونه ؟")
name = string.gsub(name,"المرايه","ارى كل شيئ من دون عيون من اكون ؟ ")
name = string.gsub(name,"الضوء","ما هو الشيئ الذي يخترق الزجاج ولا يكسره ؟")
name = string.gsub(name,"الهواء","ما هو الشيئ الذي يسير امامك ولا تراه ؟")
name = string.gsub(name,"الضل","ما هو الشيئ الذي يلاحقك اينما تذهب ؟ ")
name = string.gsub(name,"العمر","ما هو الشيء الذي كلما طال قصر ؟ ")
name = string.gsub(name,"القلم","ما هو الشيئ الذي يكتب ولا يقرأ ؟")
name = string.gsub(name,"المشط","له أسنان ولا يعض ما هو ؟ ")
name = string.gsub(name,"الحفره","ما هو الشيئ اذا أخذنا منه ازداد وكبر ؟")
name = string.gsub(name,"البحر","ما هو الشيئ الذي يرفع اثقال ولا يقدر يرفع مسمار ؟")
name = string.gsub(name,"الثلج","انا ابن الماء فان تركوني في الماء مت فمن انا ؟")
name = string.gsub(name,"الاسفنج","كلي ثقوب ومع ذالك احفض الماء فمن اكون ؟")
name = string.gsub(name,"الصوت","اسير بلا رجلين ولا ادخل الا بالاذنين فمن انا ؟")
name = string.gsub(name,"بلم","حامل ومحمول نصف ناشف ونصف مبلول فمن اكون ؟ ")
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اسرع واحد يحل الحزوره ↓\n {"..name.."}","md",true)  
end
if text == "معاني" then
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
redis:del(bot_id.."Set:Maany"..msg.chat_id)
Maany_Rand = {"قرد","دجاجه","بطريق","ضفدع","بومه","نحله","ديك","جمل","بقره","دولفين","تمساح","قرش","نمر","اخطبوط","سمكه","خفاش","اسد","فأر","ذئب","فراشه","عقرب","زرافه","قنفذ","تفاحه","باذنجان"}
name = Maany_Rand[math.random(#Maany_Rand)]
redis:set(bot_id.."Game:Meaningof"..msg.chat_id,name)
name = string.gsub(name,"قرد","🐒")
name = string.gsub(name,"دجاجه","🐔")
name = string.gsub(name,"بطريق","🐧")
name = string.gsub(name,"ضفدع","🐸")
name = string.gsub(name,"بومه","🦉")
name = string.gsub(name,"نحله","🐝")
name = string.gsub(name,"ديك","🐓")
name = string.gsub(name,"جمل","🐫")
name = string.gsub(name,"بقره","🐄")
name = string.gsub(name,"دولفين","🐬")
name = string.gsub(name,"تمساح","🐊")
name = string.gsub(name,"قرش","🦈")
name = string.gsub(name,"نمر","??")
name = string.gsub(name,"اخطبوط","🐙")
name = string.gsub(name,"سمكه","🐟")
name = string.gsub(name,"خفاش","🦇")
name = string.gsub(name,"اسد","🦁")
name = string.gsub(name,"فأر","🐭")
name = string.gsub(name,"ذئب","🐺")
name = string.gsub(name,"فراشه","🦋")
name = string.gsub(name,"عقرب","🦂")
name = string.gsub(name,"زرافه","🦒")
name = string.gsub(name,"قنفذ","🦔")
name = string.gsub(name,"تفاحه","??")
name = string.gsub(name,"باذنجان","🍆")
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اسرع واحد يرسل معنى السمايل ~ ("..name..")","md",true)  
end
---------------
if text == "حجره" or text == "حجرة" then
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
baniusernamep = '- اختار حجره / ورقة / مقص'
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '✂️', data = msg.sender_id.user_id..'/mks'},{text = '📄', data = msg.sender_id.user_id..'/orka'},{text = '🪨️', data = msg.sender_id.user_id..'/hagra'},
},
}
}
return bot.sendText(msg.chat_id,msg.id,baniusernamep,"md",false, false, false, false, reply_markup)

end
--------------
if text == "العكس" then
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
redis:del(bot_id.."Set:Aks"..msg.chat_id)
katu = {"باي","فهمت","موزين","اسمعك","احبك","موحلو","نضيف","حاره","ناصي","جوه","سريع","ونسه","طويل","سمين","ضعيف","شريف","شجاع","رحت","عدل","نشيط","شبعان","موعطشان","خوش ولد","اني","هادئ"}
name = katu[math.random(#katu)]
redis:set(bot_id.."Game:Reflection"..msg.chat_id,name)
name = string.gsub(name,"باي","هلو")
name = string.gsub(name,"فهمت","مافهمت")
name = string.gsub(name,"موزين","زين")
name = string.gsub(name,"اسمعك","ماسمعك")
name = string.gsub(name,"احبك","ماحبك")
name = string.gsub(name,"موحلو","حلو")
name = string.gsub(name,"نضيف","وصخ")
name = string.gsub(name,"حاره","بارده")
name = string.gsub(name,"ناصي","عالي")
name = string.gsub(name,"جوه","فوك")
name = string.gsub(name,"سريع","بطيء")
name = string.gsub(name,"ونسه","ضوجه")
name = string.gsub(name,"طويل","قزم")
name = string.gsub(name,"سمين","ضعيف")
name = string.gsub(name,"ضعيف","قوي")
name = string.gsub(name,"شريف","كواد")
name = string.gsub(name,"شجاع","جبان")
name = string.gsub(name,"رحت","اجيت")
name = string.gsub(name,"عدل","ميت")
name = string.gsub(name,"نشيط","كسول")
name = string.gsub(name,"شبعان","جوعان")
name = string.gsub(name,"موعطشان","عطشان")
name = string.gsub(name,"خوش ولد","موخوش ولد")
name = string.gsub(name,"اني","مطي")
name = string.gsub(name,"هادئ","عصبي")
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اسرع واحد يرسل عكس ("..name..")","md",true)  
end
if text == "بات" or text == "محيبس" then   
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '➀ » { 👊 }', data = '/Mahibes1'}, {text = '➁ » { 👊 }', data = '/Mahibes2'}, 
},
{
{text = '➂ » { 👊 }', data = '/Mahibes3'}, {text = '➃ » { 👊 }', data = '/Mahibes4'}, 
},
{
{text = '➄ » { 👊 }', data = '/Mahibes5'}, {text = '➅ » { 👊 }', data = '/Mahibes6'}, 
},
}
}
return bot.sendText(msg.chat_id,msg.id, [[*
 لعبه المحيبس هي لعبة الحظ 
⤈︙ جرب حظك مع البوت 
⤈︙ كل ما عليك هو الضغط على احدى العضمات في الازرار
*]],"md",false, false, false, false, reply_markup)
end
if text == "صراحه" or text == "صراحة" then
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ اوامر التسليه معطله بواسطه المشرفين .","md",true)
end
local texting = {
     'صراحه  |  صوتك حلوة؟',
     'صراحه  |  التقيت الناس مع وجوهين؟',
     'صراحه  |  أنت شخص ضعيف عندما؟',
     'صراحه  |  أشجع شيء حلو في حياتك؟',
     'صراحه  |  طريقة جيدة يقنع حتى لو كانت الفكرة خاطئة" توافق؟',
     'صراحه  |  كيف تتصرف مع من يسيئون فهمك ويأخذ على ذهنه ثم ينتظر أن يرفض؟',
     'صراحه  |  ‏‏إذا أحد قالك كلام سيء بالغالب وش تكون ردة فعلك؟',
     'صراحه  |  شخص معك بالحلوه والمُره؟',
     'صراحه  |  ‏هل تحب إظهار حبك وتعلقك بالشخص أم ترى ذلك ضعف؟',
     'صراحه  |  تأخذ بكلام اللي ينصحك ولا تسوي اللي تبي؟',
     'صراحه  |  وش تتمنى الناس تعرف عليك؟',
     'صراحه  |  ابيع المجرة عشان؟',
     'صراحه  |  أحيانا احس ان الناس ، كمل؟',
     'صراحه  |  مع مين ودك تنام اليوم؟',
     'صراحه  |  صدفة العمر الحلوة هي اني؟',
     'صراحه  |  الكُره العظيم دايم يجي بعد حُب قوي " تتفق؟',
     'صراحه  |  صفة تحبها في نفسك؟',
     'صراحه  |  ‏الفقر فقر العقول ليس الجيوب " ، تتفق؟',
     'صراحه  |  تصلي صلواتك الخمس كلها؟',
     'صراحه  |  ‏تجامل أحد على راحتك؟',
     'صراحه  |  اشجع شيء سويتة بحياتك؟',
     'صراحه  |  وش ناوي تسوي اليوم؟',
     'صراحه  |  وش شعورك لما تشوف المطر؟',
     'صراحه  |  غيرتك هاديه ولا تسوي مشاكل؟',
     'صراحه  |  ما اكثر شي ندمن عليه؟',
     'صراحه  |  اي الدول تتمنى ان تزورها؟',
     'صراحه  |  تقيم حظك ؟ من عشره؟',
      'صراحه  |  هل تعتقد ان حظك سيئ؟',
     'صراحه  |  شـخــص تتمنــي الإنتقــام منـــه؟',
     'صراحه  |  كلمة تود سماعها كل يوم؟',
     'صراحه  |  هل تُتقن عملك أم تشعر بالممل؟',
     'صراحه  |  هل قمت بانتحال أحد الشخصيات لتكذب على من حولك؟',
     'صراحه  |  متى آخر مرة قمت بعمل مُشكلة كبيرة وتسببت في خسائر؟',
     'صراحه  |  ما هو اسوأ خبر سمعته بحياتك؟',
     '‏صراحه | هل جرحت شخص تحبه من قبل ؟',
     'صراحه  |  ما هي العادة التي تُحب أن تبتعد عنها؟',
     '‏صراحه | هل تحب عائلتك ام تكرههم؟',
     '‏صراحه  |  من هو الشخص الذي يأتي في قلبك بعد الله – سبحانه وتعالى- ورسوله الكريم – صلى الله عليه وسلم؟',
     '‏صراحه  |  هل خجلت من نفسك من قبل؟',
     '‏صراحه  |  ما هو ا الحلم  الذي لم تستطيع ان تحققه؟',
     '‏صراحه  |  ما هو الشخص الذي تحلم به كل ليلة؟',
     '‏صراحه  |  هل تعرضت إلى موقف مُحرج جعلك تكره صاحبهُ؟',
      '‏صراحه  |  هل قمت بالبكاء أمام من تُحب؟',
     '‏صراحه  |  ماذا تختار حبيبك أم صديقك؟',
     '‏صراحه  | هل حياتك سعيدة أم حزينة؟',
     'صراحه  |  ما هي أجمل سنة عشتها بحياتك؟',
     '‏صراحه  |  ما هو عمرك الحقيقي؟',
     '‏صراحه  |  ما اكثر شي ندمن عليه؟',
     'صراحه  |  ما هي أمنياتك المُستقبلية؟‏',
     }
return bot.sendText(msg.chat_id,msg.id, texting[math.random(#texting)],'md', true)
end
if text == "خيرني" or text == "لو خيروك" or text == "لوخيروك" then 
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ اوامر التسليه معطله بواسطه المشرفين .","md",true)
end
local texting = {"لو خيروك |  بين الإبحار لمدة أسبوع كامل أو السفر على متن طائرة لـ 3 أيام متواصلة؟ ",
"لو خيروك |  بين شراء منزل صغير أو استئجار فيلا كبيرة بمبلغ معقول؟ ",
"لو خيروك |  أن تعيش قصة فيلم هل تختار الأكشن أو الكوميديا؟ ",
"لو خيروك |  بين تناول البيتزا وبين الايس كريم وذلك بشكل دائم؟ ",
"لو خيروك |  بين إمكانية تواجدك في الفضاء وبين إمكانية تواجدك في البحر؟ ",
"لو خيروك |  بين تغيير وظيفتك كل سنة أو البقاء بوظيفة واحدة طوال حياتك؟ ",
"لو خيروك |  أسئلة محرجة أسئلة صراحة ماذا ستختار؟ ",
"لو خيروك |  بين الذهاب إلى الماضي والعيش مع جدك أو بين الذهاب إلى المستقبل والعيش مع أحفادك؟ ",
"لو كنت شخص اخر هل تفضل البقاء معك أم أنك ستبتعد عن نفسك؟ ",
"لو خيروك |  بين الحصول على الأموال في عيد ميلادك أو على الهدايا؟ ",
"لو خيروك |  بين القفز بمظلة من طائرة أو الغوص في أعماق البحر؟ ",
"لو خيروك |  بين الاستماع إلى الأخبار الجيدة أولًا أو الاستماع إلى الأخبار السيئة أولًا؟ ",
    "لو خيروك بين العيش وحدك في جزيرة كبيرة منعزلة مع أكبر درجات الرفاهية وبين العيش في مكان قديم ولكن مع أصدقائك المقربين.",
    "لو خيروك بين فقدان ذاكرتك والعيش مع أصدقائك وأقربائك أو بقاء ذاكرتك ولكن العيش وحيد.",
    "للو خيروك بين تناول الخضار والفاكهة طوال حياتك أو تناول اللحوم.",
    "لو خيروك بين رؤية الأشباح فقط أو سماع صوتها فقط.",
    "لو خيروك بين القدرة على سماع أفكار الناس أو القدرة على العودة في الزمن للخلف.",
    "لو خيروك بين القدرة على الاختفاء أو القدرة على الطيران.",
    "لو خيروك بين أن تعيش 5 دقائق في الماضي أو أن تعيشها في المستقبل.",
    "لو خيروك بين 5 ملايين دينار أو 5 ملايين لحظة سعادة حقيقيةا.",
    "لو خيروك بين الاعتذار عن خطأ اقترفته أو أن يقدم لك شخص أخطأ في حقق اعتذار.",
    "لو خيروك بين الحقد أو المسامحة.",
    "لو خيروك بين إنقاذ نفسك أو إنقاذ شخص وقد يعرضك ذلك للأذى.",
    "لو خيروك بين أن تعيش في القرن الرابع عشر أو القرن الحالي.",
    "لو خيروك بين امتلاك سرعة الفهد أو دهاء الثعلب.",
    "لو خيروك بين أن تحصل على درجة كاملة في كامل اختباراتك القادمة والسابقة أو أن تسافر إلى بلد تحبه.",
    "لو خيروك بين العيش بجانب الجبال والحدائق والأشجار أو العيش بجانب البحر.",
    "لو خيروك بين تحقيق 3 أمنيات (لا تتعلق بأشخاص) أو اختيار 3 أشخاص للعيش معهم طوال حياتك.",
    "لو خيروك بين النوم في غابة مظلمة أو على ظهر سفينة في يوم عاصف.",
    "لو خيروك بين المال أو الجمال.",
    "لو خيروك بين المال أو الذكاء.",
    "لو خيروك بين المال أو الصحة.",
    "لو خيروك بين الجمال أو الذكاء.",
    "لو خيروك بين الذكاء أو الصحة.",
    "لو خيروك بين إرسال رسالة صوتية لأمك مدة دقيقة كاملة لا تحتوي إلا على صراخك وخوفك، أو كسر بيضة نيئة على رأسك.",
"لو خيروك |  بين أن تكون رئيس لشركة فاشلة أو أن تكون موظف في شركة ناجحة؟ ",
"لو خيروك |  بين أن يكون لديك جيران صاخبون أو أن يكون لديك جيران فضوليون؟ ",
"لو خيروك |  بين أن تكون شخص مشغول دائمًا أو أن تكون شخص يشعر بالملل دائمًا؟ ",
"لو خيروك |  بين قضاء يوم كامل مع الرياضي الذي تشجعه أو نجم السينما الذي تحبه؟ ",
"لو خيروك |  بين استمرار فصل الشتاء دائمًا أو بقاء فصل الصيف؟ ",
"لو خيروك |  بين العيش في القارة القطبية أو العيش في الصحراء؟ ",
"لو خيروك |  بين أن تكون لديك القدرة على حفظ كل ما تسمع أو تقوله وبين القدرة على حفظ كل ما تراه أمامك؟ ",
"لو خيروك |  بين أن يكون طولك 150 سنتي متر أو أن يكون 190 سنتي متر؟ ",
"لو خيروك |  بين إلغاء رحلتك تمامًا أو بقائها ولكن فقدان الأمتعة والأشياء الخاص بك خلالها؟ ",
"لو خيروك |  بين أن تكون اللاعب الأفضل في فريق كرة فاشل أو أن تكون لاعب عادي في فريق كرة ناجح؟ ",
"لو خيروك |  بين ارتداء ملابس البيت لمدة أسبوع كامل أو ارتداء البدلة الرسمية لنفس المدة؟ ",
"لو خيروك |  بين امتلاك أفضل وأجمل منزل ولكن في حي سيء أو امتلاك أسوأ منزل ولكن في حي جيد وجميل؟ ",
"لو خيروك |  بين أن تكون غني وتعيش قبل 500 سنة، أو أن تكون فقير وتعيش في عصرنا الحالي؟ ",
"لو خيروك |  بين ارتداء ملابس الغوص ليوم كامل والذهاب إلى العمل أو ارتداء ملابس جدك/جدتك؟ ",
"لو خيروك |  بين قص شعرك بشكل قصير جدًا أو صبغه باللون الوردي؟ ",
"لو خيروك |  بين أن تضع الكثير من الملح على كل الطعام بدون علم أحد، أو أن تقوم بتناول شطيرة معجون أسنان؟ ",
"لو خيروك |  بين قول الحقيقة والصراحة الكاملة مدة 24 ساعة أو الكذب بشكل كامل مدة 3 أيام؟ ",
"لو خيروك |  بين تناول الشوكولا التي تفضلها لكن مع إضافة رشة من الملح والقليل من عصير الليمون إليها أو تناول ليمونة كاملة كبيرة الحجم؟ ",
"لو خيروك |  بين وضع أحمر الشفاه على وجهك ما عدا شفتريكس أو وضع ماسكارا على شفتريكس فقط؟ ",
"لو خيروك |  بين الرقص على سطح منزلك أو الغناء على نافذتك؟ ",
"لو خيروك |  بين تلوين شعرك كل خصلة بلون وبين ارتداء ملابس غير متناسقة لمدة أسبوع؟ ",
"لو خيروك |  بين تناول مياه غازية مجمدة وبين تناولها ساخنة؟ ",
"لو خيروك |  بين تنظيف شعرك بسائل غسيل الأطباق وبين استخدام كريم الأساس لغسيل الأطباق؟ ",
"لو خيروك |  بين تزيين طبق السلطة بالبرتقال وبين إضافة البطاطا لطبق الفاكهة؟ ",
"لو خيروك |  بين اللعب مع الأطفال لمدة 7 ساعات أو الجلوس دون فعل أي شيء لمدة 24 ساعة؟ ",
"لو خيروك |  بين شرب كوب من الحليب أو شرب كوب من شراب عرق السوس؟ ",
"لو خيروك |  بين الشخص الذي تحبه وصديق الطفولة؟ ",
"لو خيروك |  بين أختك وأخيك؟ ",
"لو خيروك |  بين صديق قام بغدرك وعدوك؟ ",
"لو خيروك |  بين خسارة حبيبك/حبيبتك أو خسارة أخيك/أختك؟ ",
"لو خيروك |  بإنقاذ شخص واحد مع نفسك بين أمك أو ابنك؟ ",
"لو خيروك |  بين ابنك وابنتك؟ ",
"لو خيروك |  بين زوجتك وابنك/ابنتك؟ ",
"لو خيروك |  بين جدك أو جدتك؟ ",
"لو خيروك |  بين زميل ناجح وحده أو زميل يعمل كفريق؟ ",
"لو خيروك |  بين لاعب كرة قدم مشهور أو موسيقي مفضل بالنسبة لك؟ ",
"لو خيروك |  بين مصور فوتوغرافي جيد وبين مصور سيء ولكنه عبقري فوتوشوب؟ ",
"لو خيروك |  بين سائق سيارة يقودها ببطء وبين سائق يقودها بسرعة كبيرة؟ ",
"لو خيروك |  بين أستاذ اللغة العربية أو أستاذ الرياضيات؟ ",
"لو خيروك |  بين أخيك البعيد أو جارك القريب؟ ",
"لو خيروك |  يبن صديقك البعيد وبين زميلك القريب؟ ",
"لو خيروك |  بين رجل أعمال أو أمير؟ ",
"لو خيروك |  بين نجار أو حداد؟ ",
"لو خيروك |  بين طباخ أو خياط؟ ",
"لو خيروك |  بين أن تكون كل ملابس بمقاس واحد كبير الحجم أو أن تكون جميعها باللون الأصفر؟ ",
"لو خيروك |  بين أن تتكلم بالهمس فقط طوال الوقت أو أن تصرخ فقط طوال الوقت؟ ",
"لو خيروك |  بين أن تمتلك زر إيقاف موقت للوقت أو أن تمتلك أزرار للعودة والذهاب عبر الوقت؟ ",
"لو خيروك |  بين أن تعيش بدون موسيقى أبدًا أو أن تعيش بدون تلفاز أبدًا؟ ",
"لو خيروك |  بين أن تعرف متى سوف تموت أو أن تعرف كيف سوف تموت؟ ",
"لو خيروك |  بين العمل الذي تحلم به أو بين إيجاد شريك حياتك وحبك الحقيقي؟ ",
"لو خيروك |  بين معاركة دب أو بين مصارعة تمساح؟ ",
"لو خيروك |  بين إما الحصول على المال أو على المزيد من الوقت؟ ",
"لو خيروك |  بين امتلاك قدرة التحدث بكل لغات العالم أو التحدث إلى الحيوانات؟ ",
"لو خيروك |  بين أن تفوز في اليانصيب وبين أن تعيش مرة ثانية؟ ",
"لو خيروك |  بأن لا يحضر أحد إما لحفل زفافك أو إلى جنازتك؟ ",
"لو خيروك |  بين البقاء بدون هاتف لمدة شهر أو بدون إنترنت لمدة أسبوع؟ ",
"لو خيروك |  بين العمل لأيام أقل في الأسبوع مع زيادة ساعات العمل أو العمل لساعات أقل في اليوم مع أيام أكثر؟ ",
"لو خيروك |  بين مشاهدة الدراما في أيام السبعينيات أو مشاهدة الأعمال الدرامية للوقت الحالي؟ ",
"لو خيروك |  بين التحدث عن كل شيء يدور في عقلك وبين عدم التحدث إطلاقًا؟ ",
"لو خيروك |  بين مشاهدة فيلم بمفردك أو الذهاب إلى مطعم وتناول العشاء بمفردك؟ ",
"لو خيروك |  بين قراءة رواية مميزة فقط أو مشاهدتها بشكل فيلم بدون القدرة على قراءتها؟ ",
"لو خيروك |  بين أن تكون الشخص الأكثر شعبية في العمل أو المدرسة وبين أن تكون الشخص الأكثر ذكاءً؟ ",
"لو خيروك |  بين إجراء المكالمات الهاتفية فقط أو إرسال الرسائل النصية فقط؟ ",
"لو خيروك |  بين إنهاء الحروب في العالم أو إنهاء الجوع في العالم؟ ",
"لو خيروك |  بين تغيير لون عينيك أو لون شعرك؟ ",
"لو خيروك |  بين امتلاك كل عين لون وبين امتلاك نمش على خديك؟ ",
"لو خيروك |  بين الخروج بالمكياج بشكل مستمر وبين الحصول على بشرة صحية ولكن لا يمكن لك تطبيق أي نوع من المكياج؟ ",
"لو خيروك |  بين أن تصبحي عارضة أزياء وبين ميك اب أرتيست؟ ",
"لو خيروك |  بين مشاهدة كرة القدم أو متابعة الأخبار؟ ",
"لو خيروك |  بين موت شخصية بطل الدراما التي تتابعينها أو أن يبقى ولكن يكون العمل الدرامي سيء جدًا؟ ",
"لو خيروك |  بين العيش في دراما قد سبق وشاهدتها ماذا تختارين بين الكوميديا والتاريخي؟ ",
"لو خيروك |  بين امتلاك القدرة على تغيير لون شعرك متى تريدين وبين الحصول على مكياج من قبل خبير تجميل وذلك بشكل يومي؟ ",
"لو خيروك |  بين نشر تفاصيل حياتك المالية وبين نشر تفاصيل حياتك العاطفية؟ ",
"لو خيروك |  بين البكاء والحزن وبين اكتساب الوزن؟ ",
"لو خيروك |  بين تنظيف الأطباق كل يوم وبين تحضير الطعام؟ ",
"لو خيروك |  بين أن تتعطل سيارتك في نصف الطريق أو ألا تتمكنين من ركنها بطريقة صحيحة؟ ",
"لو خيروك |  بين إعادة كل الحقائب التي تملكينها أو إعادة الأحذية الجميلة الخاصة بك؟ ",
"لو خيروك |  بين قتل حشرة أو متابعة فيلم رعب؟ ",
"لو خيروك |  بين امتلاك قطة أو كلب؟ ",
"لو خيروك |  بين الصداقة والحب ",
"لو خيروك |  بين تناول الشوكولا التي تحبين طوال حياتك ولكن لا يمكنك الاستماع إلى الموسيقى وبين الاستماع إلى الموسيقى ولكن لا يمكن لك تناول الشوكولا أبدًا؟ ",
"لو خيروك |  بين مشاركة المنزل مع عائلة من الفئران أو عائلة من الأشخاص المزعجين الفضوليين الذين يتدخلون في كل كبيرة وصغيرة؟ ",
} 
return bot.sendText(msg.chat_id,msg.id,texting[math.random(#texting)],'md')
end
if text == 'رياضيات' then
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
xxx = {'9','46','2','9','5','4','25','10','17','15','39','5','16',};
name = xxx[math.random(#xxx)]
print(name)
redis:set(bot_id..'bkbk6'..msg.chat_id,name)
name = string.gsub(name,'9','7 + 2 = ?') name = string.gsub(name,'46','41 + 5 = ?')
name = string.gsub(name,'2','5 - 3 = ?') name = string.gsub(name,'9','5 + 2 + 2 = ?')
name = string.gsub(name,'5','8 - 3 = ?') name = string.gsub(name,'4','40 ÷ 10 = ?')
name = string.gsub(name,'25','30 - 5 = ?') name = string.gsub(name,'10','100 ÷ 10 = ?')
name = string.gsub(name,'17','10 + 5 + 2 = ?') name = string.gsub(name,'15','25 - 10 = ?')
name = string.gsub(name,'39','44 - 5 = ?') name = string.gsub(name,'5','12 + 1 - 8 = ?') name = string.gsub(name,'16','16 + 16 - 16 = ?')
bot.sendText(msg.chat_id,msg.id,'⤈︙ اكمل المعادله \n - {'..name..'} .')  
end
if text == 'انكليزي' then
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
yyy = {'معلومات','قنوات','كروبات','كتاب','تفاحه','سدني','نقود','اعلم','ذئب','تمساح','ذكي','شاطئ','غبي',};
name = yyy[math.random(#yyy)]
redis:set(bot_id..'bot:bkbk7'..msg.chat_id,name)
name = string.gsub(name,'ذئب','Wolf') name = string.gsub(name,'معلومات','Information')
name = string.gsub(name,'قنوات','Channels') name = string.gsub(name,'كروبات','Groups')
name = string.gsub(name,'كتاب','Book') name = string.gsub(name,'تفاحه','Apple')
name = string.gsub(name,'نقود','money') name = string.gsub(name,'اعلم','I know')
name = string.gsub(name,'تمساح','crocodile') name = string.gsub(name,'شاطئ','Beach')
name = string.gsub(name,'غبي','Stupid') name = string.gsub(name,'صداقه','Friendchip')
name = string.gsub(name,'ذكي','Smart') 
bot.sendText(msg.chat_id,msg.id,' ⤈︙ ما معنى كلمه {'..name..'} ، ')     
end
if text == 'تفكيك' then
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
  katu = {'ا ح ب ك','ذ ئ ب','ب ع ي ر','ط ي ر','و ر د ه','ج م ي ل ','ح ل و','ب ط ر ي ق','ط م ا ط م','م و ز','س ي ا ر ة','ت ح ر ي ك','ف ل و س','ب و ت','ث ق ة','ح ل ز و ن','م ك ي ف','م ر و ح ه'
  };
  name = katu[math.random(#katu)]
  redis:set(bot_id..'Set_fkk'..msg.chat_id,name)
  name = string.gsub(name,'ا ح ب ك','احبك')
  name = string.gsub(name,'ا ك ر ه ك','اكرهك')
  name = string.gsub(name,'ذ ئ ب','ذئب')
  name = string.gsub(name,'ب ع ي ر','بعير')
  name = string.gsub(name,'ط ي ر','طير')
  name = string.gsub(name,'و ر د ه','ورده')
  name = string.gsub(name,'ج م ي ل','جميل')
  name = string.gsub(name,'ح ل و','حلو')
  name = string.gsub(name,'ب ط ر ي ق','بطريق')
  name = string.gsub(name,'ط م ا ط م','طماطم')
  name = string.gsub(name,'م و ز','موز')
  name = string.gsub(name,'س ي ا ر ة','سيارة')
  name = string.gsub(name,'ت ح ر ي ك','تحريك')
  name = string.gsub(name,'ف ل و س','فلوس')
  name = string.gsub(name,'ب و ت','بوت')
  name = string.gsub(name,'ث ق ة','ثقة')
  name = string.gsub(name,'ح ل ز و ن','حلزون')
  name = string.gsub(name,'م ك ي ف','مكيف')
  name = string.gsub(name,'م ر و ح ه','مروحه')
  return bot.sendText(msg.chat_id,msg.id,"⤈︙ اسرع واحد يفكك ~ "..name.."","md",true)
  end
  if text == 'تركيب' then
  if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
  katu = {'احبك','ذئب','بعير','طير','ورده','جميل ','حلو','بطريق','طماطم','موز','سيارة','تحريك','فلوس','بوت','ثقة','حلزون','مكيف','مروحه'
  };
  name = katu[math.random(#katu)]
  redis:set(bot_id..'Set_trkib'..msg.chat_id,name)
  name = string.gsub(name,'احبك','ا ح ب ك')
  name = string.gsub(name,'ذئب','ذ ئ ب')
  name = string.gsub(name,'بعير','ب ع ي ر')
  name = string.gsub(name,'طير','ط ي ر')
  name = string.gsub(name,'ورده','و ر د ه')
  name = string.gsub(name,'جميل','ج م ي ل')
  name = string.gsub(name,'حلو','ح ل و')
  name = string.gsub(name,'بطريق','ب ط ر ي ق')
  name = string.gsub(name,'طماطم','ط م ا ط م')
  name = string.gsub(name,'موز','م و ز')
  name = string.gsub(name,'سيارة','س ي ا ر ة')
  name = string.gsub(name,'تحريك','ت ح ر ي ك')
  name = string.gsub(name,'فلوس','ف ل و س')
  name = string.gsub(name,'بوت','ب و ت')
  name = string.gsub(name,'ثقة','ث ق ة')
  name = string.gsub(name,'حلزون','ح ل ز و ن')
  name = string.gsub(name,'مكيف','م ك ي ف')
  name = string.gsub(name,'مروحه','م ر و ح ه')
  return bot.sendText(msg.chat_id,msg.id,"⤈︙ اسرع واحد يركب ~ "..name.."","md",true)
  end
  if text == "اعلام" or text == "اعلام ودول" then
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
redis:del(bot_id.."Set:Country"..msg.chat_id)
Country_Rand = {"مصر","العراق","السعوديه","المانيا","تونس","الجزائر","فلسطين","اليمن","المغرب","البحرين","فرنسا","سويسرا","تركيا","انجلترا","الولايات المتحده","كندا","الكويت","ليبيا","السودان","سوريا"}
name = Country_Rand[math.random(#Country_Rand)]
redis:set(bot_id.."Game:Countrygof"..msg.chat_id,name)
name = string.gsub(name,"مصر","🇪🇬")
name = string.gsub(name,"العراق","🇮🇶")
name = string.gsub(name,"السعوديه","🇸🇦")
name = string.gsub(name,"المانيا","🇩🇪")
name = string.gsub(name,"تونس","🇹🇳")
name = string.gsub(name,"الجزائر","🇩🇿")
name = string.gsub(name,"فلسطين","🇵🇸")
name = string.gsub(name,"اليمن","🇾🇪")
name = string.gsub(name,"المغرب","🇲🇦")
name = string.gsub(name,"البحرين","🇧🇭")
name = string.gsub(name,"فرنسا","🇫🇷")
name = string.gsub(name,"سويسرا","🇨🇭")
name = string.gsub(name,"انجلترا","🇬🇧")
name = string.gsub(name,"تركيا","🇹🇷")
name = string.gsub(name,"الولايات المتحده","🇱🇷")
name = string.gsub(name,"كندا","🇨🇦")
name = string.gsub(name,"الكويت","🇰🇼")
name = string.gsub(name,"ليبيا","🇱🇾")
name = string.gsub(name,"السودان","🇸🇩")
name = string.gsub(name,"سوريا","🇸🇾")
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اسرع واحد يرسل اسم الدولة ~ ( "..name.." )","md",true)  
end

if text == "العواصم" or text == "عواصم" then
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
mthal = {"مقديشو","الدوحه","بغداد","الرياض","الحبل","بيروت","شقره","القاهره","دمشق","صنعاء","الخرطوم","عمان","ابو ضبي","طرابلس الغرب","الرباط","القدس","تونس","مسقط","الكويت","المنامه","الجزائر",};
name = mthal[math.random(#mthal)]
redis:set(bot_id.."Game:aoismm"..msg.chat_id,name)
name = string.gsub(name,"بغداد","العراق")
name = string.gsub(name,"الرياض","السعوديه")
name = string.gsub(name,"بيروت","لبنان")
name = string.gsub(name,"القاهره","مصر")
name = string.gsub(name,"دمشق","سوريا")
name = string.gsub(name,"صنعاء","اليمن")
name = string.gsub(name,"الخرطوم","السودان")
name = string.gsub(name,"عمان","الأردن")
name = string.gsub(name,"ابو ضبي","الأمارات")
name = string.gsub(name,"طرابلس الغرب","ليبيا")
name = string.gsub(name,"الرباط","المغرب")
name = string.gsub(name,"القدس","فلسطين")
name = string.gsub(name,"تونس","تونس")
name = string.gsub(name,"مسقط","عمان")
name = string.gsub(name,"الكويت","الكويت")
name = string.gsub(name,"المنامه","البحرين")
name = string.gsub(name,"الجزائر","الجزائر")
name = string.gsub(name,"الدوحه","القطر")
name = string.gsub(name,"مقديشو","الصومال")
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اسرع واحد يرسل اسم العاصمة ~ ( "..name.." ) ","md",true)  
end

if text == "ارقام" then
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
Maany_Rand = {"697045","1008761","869645","1078944","0088841","661199","998861144","5586911","984682","1078944","97945","219745","58662","197985","975465"}
name = Maany_Rand[math.random(#Maany_Rand)]
redis:set(bot_id.."Game:arkkamm"..msg.chat_id,name)
name = string.gsub(name,"197985","197985")
name = string.gsub(name,"769475","769475")
name = string.gsub(name,"975465","975465")
name = string.gsub(name,"984682","984682")
name = string.gsub(name,"58662","58662")
name = string.gsub(name,"219745","219745")
name = string.gsub(name,"97945","97945")
name = string.gsub(name,"697045","697045")
name = string.gsub(name,"1008761","1008761")
name = string.gsub(name,"869645","869645")
name = string.gsub(name,"1078944","1078944")
name = string.gsub(name,"0088841","0088841")
name = string.gsub(name,"661199","661199")
name = string.gsub(name,"998861144","998861144")
name = string.gsub(name,"5586911","5586911")
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اسرع واحد يكتب الرقم ~ ( "..name.." ) ","md",true)  
end

if text == 'عقاب' then
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
redis:del(bot_id..'List_Ahkamm'..msg.chat_id)  
redis:set(bot_id.."raeahkamm"..msg.chat_id,msg.sender_id.user_id)
redis:sadd(bot_id..'List_Ahkamm'..msg.chat_id,msg.sender_id.user_id)
redis:setex(bot_id.."Start_Ahkamm"..msg.chat_id,3600,true)
return bot.sendText(msg.chat_id,msg.id,"⤈︙ تم بدء اللعبة وتم تسجيلك \n⤈︙ اللي بيلعب يرسل ( انا ) .","md",true)
end
if text == 'نعم' and redis:get(bot_id.."Witting_StartGamehh"..msg.chat_id) then
rarahkam = redis:get(bot_id.."raeahkamm"..msg.chat_id)
if tonumber(rarahkam) == msg.sender_id.user_id then
local list = redis:smembers(bot_id..'List_Ahkamm'..msg.chat_id) 
if #list == 1 then 
return bot.sendText(msg.chat_id,msg.id,"⤈︙ عذراً لم يشارك اي لاعب","md",true)  
end 
local UserName = list[math.random(#list)]

local UserId_Info = bot.getUser(UserName)
if UserId_Info.username and UserId_Info.username ~= "" then
ls = '@['..UserId_Info.username..']'
else
ls = '['..UserId_Info.first_name..'](tg://user?id='..UserName..')'
end
redis:incrby(bot_id..'Num:Add:Games'..msg.chat_id..UserId_Info.id,5)
redis:del(bot_id..'raeahkamm'..msg.chat_id) 
redis:del(bot_id..'List_Ahkamm'..msg.chat_id) 
redis:del(bot_id.."Witting_StartGamehh"..msg.chat_id)
redis:del(bot_id.."Start_Ahkamm"..msg.chat_id)
katu = {
"**صورة وجهك او رجلك او خشمك او يدك**.",
    "**اصدر اي صوت يطلبه منك الاعبين**.",
    "**سكر خشمك و قول كلمة من اختيار الاعبين الي معك**.",
    "**روح الى اي كروب عندك في الواتس اب و اكتب اي شيء يطلبه منك الاعبين  الحد الاقصى 3 رسائل**.",
    "**قول نكتة ولازم احد الاعبين يضحك اذا ضحك يعطونك ميوت الى ان يجي دورك مرة ثانية**.",
    "**سمعنا صوتك و غن اي اغنية من اختيار الاعبين الي معك**.",
    "**ذي المرة لك لا تعيدها**.",
    "**ارمي جوالك على الارض بقوة و اذا انكسر صور الجوال و ارسله في الشات العام**.",
    "**صور اي شيء يطلبه منك الاعبين**.",
    "**اتصل على ابوك و قول له انك رحت مع بنت و احين هي حامل....**.",
    "**سكر خشمك و قول كلمة من اختيار الاعبين الي معك**.",
    "**اعطي اي احد جنبك كف اذا مافيه احد جنبك اعطي نفسك و نبي نسمع صوته**.",
    "**ارمي جوالك على الارض بقوة و اذا انكسر صور الجوال و ارسله في الشات العام**.",
    "**روح عند اي احد بالخاص و قول له انك تحبه و الخ**.",
    "**اكتب في الشات اي شيء يطلبه منك الاعبين في الخاص**.",
    "**قول نكتة اذا و لازم احد الاعبين يضحك اذا محد ضحك يعطونك ميوت الى ان يجي دورك مرة ثانية**.",
    "**سامحتك خلاص مافيه عقاب لك **.",
    "**اتصل على احد من اخوياك  خوياتك , و اطلب منهم مبلغ على اساس انك صدمت بسيارتك**.",
    "**غير اسمك الى اسم من اختيار الاعبين الي معك**.",
    "**اتصل على امك و قول لها انك تحبها **.",
    "**لا يوجد سؤال لك سامحتك **.",
    "**قل لواحد ماتعرفه عطني كف**.",
    "**منشن الجميع وقل انا اكرهكم**.",
    "**اتصل لاخوك و قول له انك سويت حادث و الخ....**.",
    "**روح المطبخ و اكسر صحن **.",
    "**اعطي اي احد جنبك كف اذا مافيه احد جنبك اعطي نفسك و نبي نسمع صوت الكف**.",
    "**قول لاي بنت موجود في الروم كلمة حلوه**.",
    "**تكلم باللغة الانجليزية الين يجي دورك مرة ثانية لازم تتكلم اذا ما تكلمت تنفذ عقاب ثاني**.",
    "**لا تتكلم ولا كلمة الين يجي دورك مرة ثانية و اذا تكلمت يجيك باند لمدة يوم كامل من السيرفر**.",
    "**قول قصيدة **.",
    "**تكلم باللهجة السودانية الين يجي دورك مرة ثانية**.",
    "**اتصل على احد من اخوياك  خوياتك , و اطلب منهم مبلغ على اساس انك صدمت بسيارتك**.",
    "**اول واحد تشوفه عطه كف**.",
    "**سو مشهد تمثيلي عن اي شيء يطلبه منك الاعبين**.",
    "**سامحتك خلاص مافيه عقاب لك **.",
    "**اتصل على ابوك و قول له انك رحت مع بنت و احين هي حامل....**.",
    "**روح اكل ملح + ليمون اذا مافيه اكل اي شيء من اختيار الي معك**.",
    "**تاخذ عقابين**.",
    "**قول اسم امك افتخر بأسم امك**.",
    "**ارمي اي شيء قدامك على اي احد موجود او على نفسك**.",
    "**اذا انت ولد اكسر اغلى او احسن عطور عندك اذا انتي بنت اكسري الروج حقك او الميك اب حقك**.",
    "**اذهب الى واحد ماتعرفه وقل له انا كيوت وابي بوسه**.",
    "**تتصل على الوالده  و تقول لها خطفت شخص**.",
    "** تتصل على الوالده  و تقول لها تزوجت با سر**.",
    "**اتصل على الوالده  و تقول لها  احب وحده**.",
      "**تتصل على شرطي تقول له عندكم مطافي**.",
      "**خلاص سامحتك**.",
      "** تصيح في الشارع انا  مجنوون**.",
      "** تروح عند شخص وقول له احبك**."
      }
name = katu[math.random(#katu)]
return bot.sendText(msg.chat_id,msg.id,'⤈︙ تم اختيار '..ls..' لمعاقبته\n- العقوبة هي ( '..name..' ) ',"md",true)
end
end

if text == 'احكام' then
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
redis:del(bot_id..'List_Ahkam'..msg.chat_id)  
redis:set(bot_id.."raeahkam"..msg.chat_id,msg.sender_id.user_id)
redis:sadd(bot_id..'List_Ahkam'..msg.chat_id,msg.sender_id.user_id)
redis:setex(bot_id.."Start_Ahkam"..msg.chat_id,3600,true)
return bot.sendText(msg.chat_id,msg.id,"⤈︙ تم بدء اللعبة وتم تسجيلك \n⤈︙ اللي بيلعب يرسل ( انا ) .","md",true)
end
if text == 'نعم' and redis:get(bot_id.."Witting_StartGameh"..msg.chat_id) then
rarahkam = redis:get(bot_id.."raeahkam"..msg.chat_id)
if tonumber(rarahkam) == msg.sender_id.user_id then
local list = redis:smembers(bot_id..'List_Ahkam'..msg.chat_id) 
if #list == 1 then 
return bot.sendText(msg.chat_id,msg.id,"⤈︙ عذراً لم يشارك اي لاعب","md",true)  
end 
local UserName = list[math.random(#list)]

local UserId_Info = bot.getUser(UserName)
if UserId_Info.username and UserId_Info.username ~= "" then
ls = '@['..UserId_Info.username..']'
else
ls = '['..UserId_Info.first_name..'](tg://user?id='..UserName..')'
end
redis:incrby(bot_id..'Num:Add:Games'..msg.chat_id..UserId_Info.id,5)
redis:del(bot_id..'raeahkam'..msg.chat_id) 
redis:del(bot_id..'List_Ahkam'..msg.chat_id) 
redis:del(bot_id.."Witting_StartGameh"..msg.chat_id)
redis:del(bot_id.."Start_Ahkam"..msg.chat_id)
return bot.sendText(msg.chat_id,msg.id,'⤈︙ تم اختيار '..ls..' للحكم عليه',"md",true)
end
end

if text == 'اضف صور' then
if not developer(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المطور * ',"md",true)  
end
redis:set(bot_id.."Add:photo:Gamess"..msg.sender_id.user_id..":"..msg.chat_id,'startt')
return bot.sendText(msg.chat_id,msg.id,"⤈︙ ارسل الصورة الان","md",true)  
end

if text == "مسح قائمه الصور" then
if not developer(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المطور* ',"md",true)  
end
local list = redis:smembers(bot_id.."photo:Games:Bott")
if #list == 0 then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ لا يوجد اسئلة","md",true)
end
for k,v in pairs(list) do
redis:del(bot_id..'Text:Games:photoo'..v)  
redis:srem(bot_id.."photo:Games:Bott",v)  
end
return bot.sendText(msg.chat_id,msg.id,"⤈︙ تم مسح جميع الاسئلة","md",true) 
end
if text == 'صور' then
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
local list = redis:smembers(bot_id.."photo:Games:Bott")
if #list == 0 then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ لا يوجد اسئلة","md",true) 
end
local quschen = list[math.random(#list)]
local GetAnswer = redis:get(bot_id..'Text:Games:photoo'..quschen)
print(GetAnswer)
redis:set(bot_id..'Games:Set:Answerr'..msg.chat_id,GetAnswer)
return bot.sendPhoto(msg.chat_id,msg.id,quschen,"","md",true) 
end

if text == 'اضف رياضه' then
if not developer(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المطور * ',"md",true)  
end
redis:set(bot_id.."Add:photo:Gamesss"..msg.sender_id.user_id..":"..msg.chat_id,'starttt')
return bot.sendText(msg.chat_id,msg.id,"⤈︙ ارسل الصورة الان","md",true)  
end

if text == "مسح قائمه رياضه" then
if not developer(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المطور* ',"md",true)  
end
local list = redis:smembers(bot_id.."photo:Games:Bottt")
if #list == 0 then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ لا يوجد اسئلة","md",true)
end
for k,v in pairs(list) do
redis:del(bot_id..'Text:Games:photooo'..v)  
redis:srem(bot_id.."photo:Games:Bottt",v)  
end
return bot.sendText(msg.chat_id,msg.id,"⤈︙ تم مسح جميع الاسئلة","md",true) 
end
if text == 'رياضه' or text == 'رياضة' then
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
local list = redis:smembers(bot_id.."photo:Games:Bottt")
if #list == 0 then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ لا يوجد اسئلة","md",true) 
end
local quschen = list[math.random(#list)]
local GetAnswer = redis:get(bot_id..'Text:Games:photooo'..quschen)
print(GetAnswer)
redis:set(bot_id..'Games:Set:Answerrr'..msg.chat_id,GetAnswer)
return bot.sendPhoto(msg.chat_id,msg.id,quschen,"","md",true) 
end

if text == 'اضف موسيقى' then
if not developer(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المطور * ',"md",true)  
end
redis:set(bot_id.."Add:audio:Games"..msg.sender_id.user_id..":"..msg.chat_id,'start')
return bot.sendText(msg.chat_id,msg.id,"⤈︙ ارسل الموسيقى الان","md",true)  
end

if text == "مسح قائمه الموسيقى" then
if not developer(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المطور * ',"md",true)  
end
local list = redis:smembers(bot_id.."audio:Games:Bot")
if #list == 0 then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ لا يوجد اسئلة","md",true)
end
for k,v in pairs(list) do
redis:del(bot_id..'Text:Games:audio'..v)  
redis:srem(bot_id.."audio:Games:Bot",v)  
end
return bot.sendText(msg.chat_id,msg.id,"⤈︙ تم مسح جميع الاسئلة","md",true) 
end
if text == 'موسيقى' then
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
local list = redis:smembers(bot_id.."audio:Games:Bot")
if #list == 0 then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ لا يوجد اسئلة","md",true) 
end
local quschen = list[math.random(#list)]
local GetAnswer = redis:get(bot_id..'Text:Games:audio'..quschen)
print(GetAnswer)
redis:set(bot_id..'Games:Set:Answer'..msg.chat_id,GetAnswer)
return bot.sendAudio(msg.chat_id,msg.id,quschen,"","md",true) 
end

if text == 'اضف مشاهير' then
if not developer(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المطور * ',"md",true)  
end
redis:set(bot_id.."Add:photo:Gamesssss"..msg.sender_id.user_id..":"..msg.chat_id,'starttttt')
return bot.sendText(msg.chat_id,msg.id,"⤈︙ ارسل الصورة الان","md",true)  
end

if text == "مسح قائمه المشاهير" then
if not developer(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المطور* ',"md",true)  
end
local list = redis:smembers(bot_id.."photo:Games:Bottttt")
if #list == 0 then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ لا يوجد اسئلة","md",true)
end
for k,v in pairs(list) do
redis:del(bot_id..'Text:Games:photooooo'..v)  
redis:srem(bot_id.."photo:Games:Bottttt",v)  
end
return bot.sendText(msg.chat_id,msg.id,"⤈︙ تم مسح جميع الاسئلة","md",true) 
end
if text == 'مشاهير' or text == 'المشاهير' then
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
local list = redis:smembers(bot_id.."photo:Games:Bottttt")
if #list == 0 then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ لا يوجد اسئلة","md",true) 
end
local quschen = list[math.random(#list)]
local GetAnswer = redis:get(bot_id..'Text:Games:photooooo'..quschen)
print(GetAnswer)
redis:set(bot_id..'Games:Set:Answerrrrr'..msg.chat_id,GetAnswer)
return bot.sendPhoto(msg.chat_id,msg.id,quschen,"","md",true) 
end

if text == "كلمات" then
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
redis:del(bot_id.."Set:Klmat"..msg.chat_id)
katu = {"باي","فهمت","كتاب","اسمعك","احبك","بشع","نظيف","حار","بارد","اسفل","سريع","سيء","طويل","سمين","ضعيف","شريف","شجاع","ذهب","عدل","نشيط","جوعان","عطشان","هادئ","قرد","دجاجه","بطريق","ضفدع","بومه","نحله","ديك","جمل","بقره","دولفين","تمساح","قرش","نمر","اخطبوط","سمكه","خفاش","اسد","فار","ذئب","فراشه","عقرب","زرافه","قنفذ","تفاحه","باذنجان","الجرس","السمك","المطر","الكتاب","البسمار","الكعبه","الابره","الساعه","البيض","المرايه","الضوء","الهواء","الضل","العمر","القلم","المشط","الحفره","البحر","الثلج","الاسفنج","الصوت"}
name = katu[math.random(#katu)]
redis:set(bot_id.."Game:Kokoo"..msg.chat_id,name)
name = string.gsub(name,"باي","باي")
name = string.gsub(name,"فهمت","فهمت")
name = string.gsub(name,"كتاب","كتاب")
name = string.gsub(name,"اسمعك","اسمعك")
name = string.gsub(name,"احبك","احبك")
name = string.gsub(name,"بشع","بشع")
name = string.gsub(name,"نظيف","نظيف")
name = string.gsub(name,"حار","حار")
name = string.gsub(name,"بارد","بارد")
name = string.gsub(name,"اسفل","اسفل")
name = string.gsub(name,"سريع","سريع")
name = string.gsub(name,"سيء","سيء")
name = string.gsub(name,"طويل","طويل")
name = string.gsub(name,"سمين","سمين")
name = string.gsub(name,"ضعيف","ضعيف")
name = string.gsub(name,"شريف","شريف")
name = string.gsub(name,"شجاع","شجاع")
name = string.gsub(name,"ذهب","ذهب")
name = string.gsub(name,"عدل","عدل")
name = string.gsub(name,"نشيط","نشيط")
name = string.gsub(name,"جوعان","جوعان")
name = string.gsub(name,"عطشان","عطشان")
name = string.gsub(name,"هادئ","هادئ")
name = string.gsub(name,"قرد","قرد")
name = string.gsub(name,"دجاجه","دجاجه")
name = string.gsub(name,"بطريق","بطريق")
name = string.gsub(name,"ضفدع","ضفدع")
name = string.gsub(name,"بومه","بومه")
name = string.gsub(name,"نحله","نحله")
name = string.gsub(name,"ديك","ديك")
name = string.gsub(name,"جمل","جمل")
name = string.gsub(name,"بقره","بقره")
name = string.gsub(name,"دولفين","دولفين")
name = string.gsub(name,"تمساح","تمساح")
name = string.gsub(name,"قرش","قرش")
name = string.gsub(name,"نمر","نمر")
name = string.gsub(name,"اخطبوط","اخطبوط")
name = string.gsub(name,"سمكه","سمكه")
name = string.gsub(name,"خفاش","خفاش")
name = string.gsub(name,"اسد","اسد")
name = string.gsub(name,"فار","فار")
name = string.gsub(name,"ذئب","ذئب")
name = string.gsub(name,"فراشه","فراشه")
name = string.gsub(name,"عقرب","عقرب")
name = string.gsub(name,"زرافه","زرافه")
name = string.gsub(name,"قنفذ","قنفذ")
name = string.gsub(name,"تفاحه","تفاحه")
name = string.gsub(name,"باذنجان","باذنجان")
name = string.gsub(name,"الجرس","الجرس")
name = string.gsub(name,"السمك","السمك")
name = string.gsub(name,"المطر","المطر")
name = string.gsub(name,"الكتاب","الكتاب")
name = string.gsub(name,"البسمار","البسمار")
name = string.gsub(name,"الكعبه","الكعبه")
name = string.gsub(name,"الابره","الابره")
name = string.gsub(name,"الساعه","الساعه")
name = string.gsub(name,"البيض","البيض")
name = string.gsub(name,"المرايه","المرايه")
name = string.gsub(name,"الضوء","الضوء")
name = string.gsub(name,"الهواء","الهواء")
name = string.gsub(name,"الضل","الضل")
name = string.gsub(name,"العمر","العمر")
name = string.gsub(name,"القلم","القلم")
name = string.gsub(name,"المشط","المشط")
name = string.gsub(name,"الحفره","الحفره")
name = string.gsub(name,"البحر","البحر")
name = string.gsub(name,"الثلج","الثلج")
name = string.gsub(name,"الاسفنج","الاسفنج")
name = string.gsub(name,"الصوت","الصوت")
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اسرع واحد يرسل ~ ( "..name.." )","md",true)  
end
if text == "خمن" or text == "تخمين" then   
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game:Estimate")
Num = math.random(1,20)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game:Estimate",Num)  
return bot.sendText(msg.chat_id,msg.id,"*⤈︙ اهلا بك عزيزي في لعبة التخمين \n⤈︙ ملاحظه لديك { 3 } محاولات فقط فكر قبل ارسال تخمينك \n⤈︙ سيتم تخمين عدد ما بين (1 و 20 ) اذا تعتقد انك تستطيع الفوز جرب والعب الان ؟*","md",true)  
end
if text == "المختلف" then
if not redis:get(bot_id.."Status:Games"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الالعاب معطله بواسطه المشرفين .","md",true)
end
redis:del(bot_id..":"..msg.chat_id..":game:Difference")
mktlf = {"??","☠","🐼","🐇","🌑","🌚","⭐️","✨","⛈","??","⛄️","👨‍??","👨‍💻","??‍🔧","??‍♀","??‍♂","🧝‍♂","🙍‍♂","🧖‍♂","👬","🕒","🕤","⌛️","??",};
name = mktlf[math.random(#mktlf)]
redis:set(bot_id.."Game:Difference"..msg.chat_id,name)
name = string.gsub(name,"😸","😹😹😹😹😹😹😹😹😸😹😹😹😹")
name = string.gsub(name,"☠","💀💀💀💀💀💀💀☠💀💀💀💀💀")
name = string.gsub(name,"🐼","👻👻👻🐼👻👻??👻👻👻👻")
name = string.gsub(name,"🐇","🕊🕊🕊🕊🕊🐇🕊🕊🕊🕊")
name = string.gsub(name,"🌑","🌚🌚🌚🌚🌚🌑🌚🌚🌚")
name = string.gsub(name,"🌚","🌑🌑🌑🌑????🌑🌑🌑")
name = string.gsub(name,"⭐️","??🌟🌟🌟🌟🌟🌟🌟⭐️🌟🌟🌟")
name = string.gsub(name,"✨","💫💫💫💫💫✨??💫??💫")
name = string.gsub(name,"⛈","🌨🌨????🌨⛈🌨??🌨??")
name = string.gsub(name,"🌥","⛅️⛅️⛅️⛅️⛅️⛅️🌥⛅️⛅️⛅️⛅️")
name = string.gsub(name,"⛄️","☃☃☃☃☃☃⛄️☃☃☃☃")
name = string.gsub(name,"👨‍🔬","👩‍🔬👩‍??👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👨‍🔬👩‍🔬👩‍🔬👩‍🔬")
name = string.gsub(name,"👨‍💻","👩‍💻👩‍??👩‍‍💻👩‍‍??👩‍‍💻👨‍💻??‍💻👩‍💻👩‍💻")
name = string.gsub(name,"👨‍🔧","👩‍🔧👩‍🔧??‍??👩‍🔧👩‍🔧👩‍🔧👨‍🔧👩‍🔧")
name = string.gsub(name,"👩‍??","👨‍🍳👨‍🍳👨‍🍳👨‍🍳👨‍🍳??‍🍳👨‍🍳👨‍🍳??‍🍳")
name = string.gsub(name,"🧚‍♀","🧚‍♂🧚‍♂🧚‍♂??‍♂🧚‍♀🧚‍♂🧚‍♂")
name = string.gsub(name,"🧜‍♂","🧜‍♀🧜‍♀🧜‍♀🧜‍♀🧜‍♀🧚‍♂🧜‍♀🧜‍♀🧜‍♀")
name = string.gsub(name,"🧝‍♂","🧝‍♀🧝‍♀🧝‍♀🧝‍♀🧝‍♀🧝‍♂🧝‍♀🧝‍♀🧝‍♀")
name = string.gsub(name,"🙍‍♂️","🙎‍♂️🙎‍♂️🙎‍♂️🙎‍♂️🙎‍♂️🙍‍♂️🙎‍♂️🙎‍♂️🙎‍♂️")
name = string.gsub(name,"🧖‍♂️","🧖‍♀️🧖‍♀️🧖‍♀️🧖‍♀️🧖‍♀️🧖‍♂️🧖‍♀️🧖‍♀️🧖‍♀️🧖‍♀️")
name = string.gsub(name,"👬","👭👭👭👭👭👬👭👭👭")
name = string.gsub(name,"👨‍👨‍👧","👨‍👨‍👦👨‍👨‍👦👨‍👨‍👦👨‍👨‍👦👨‍👨‍👧👨‍👨‍👦👨‍👨‍👦")
name = string.gsub(name,"🕒","🕒🕒🕒🕒🕒🕒🕓🕒🕒🕒")
name = string.gsub(name,"🕤","🕥🕥🕥🕥🕥🕤🕥🕥🕥")
name = string.gsub(name,"⌛️","⏳⏳⏳⏳⏳⏳⌛️⏳⏳")
name = string.gsub(name,"📅","????📆📆📆📆📅????")
return bot.sendText(msg.chat_id,msg.id,"*⤈︙ اسرع واحد يرسل الاختلاف ~* ( ["..name.."] )","md",true)  
end

if text == 'القوانين' then
if redis:get(bot_id..":"..msg.chat_id..":Law") then
t = redis:get(bot_id..":"..msg.chat_id..":Law")
else
t = "*⤈︙ لم يتم وضع القوانين في الكروب *"
end
bot.sendText(msg.chat_id,msg.id,t,"md", true)
end
if text == 'بوت حذف' or text == 'رابط الحذف' or text == 'رابط حذف' or text == 'بوت الحذف' then
local Text = "*⤈︙ 𝖶𝖾𝗅𝖼𝗈𝗆 𝖳𝗈 𝖯𝗋𝖾𝗌𝗌 𝗁𝖤𝗋𝖾 ????𝗍 .*\n"
keyboard = {} 
keyboard.inline_keyboard = {
{{text = '‹ 𝖯𝗋𝖾𝗌𝗌 𝗁𝖤𝗋𝖾 ›',url="t.me/ux1bot"}},
}
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. msg.chat_id .. "&photo=https://t.me/ux1bot&caption=".. URL.escape(Text).."&photo=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if text == 'همسه' or text == 'همسة' or text == 'بوت همسه' or text == 'بوت الهمسه' then
local Text = "*⤈︙ 𝖶𝖾𝗅𝖼𝗈𝗆 𝖳𝗈 𝗁𝗂𝗌𝗌 𝖡𝗈𝗍 .*\n"
keyboard = {} 
keyboard.inline_keyboard = {
{{text = '‹ 𝗁𝗂𝗌𝗌 𝖡𝗈𝗍 ›',url="t.me/dx6bot"}},
}
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. msg.chat_id .. "&photo=https://t.me/dx6bot&caption=".. URL.escape(Text).."&photo=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if text == 'بوت اغاني' or text == 'بوت ميوزك' or text == 'ميوزك' or text == 'اريد بوت اغاني' then 
local Text = "*⤈︙ 𝖶𝖾𝗅𝖼𝗈𝗆 𝖳𝗈 𝖲𝗈𝗎𝗋𝖼𝖾 𝖯𝗋𝗈𝖷 𝖬𝗎𝗌𝗂𝖼 .*\n"
keyboard = {} 
keyboard.inline_keyboard = {
{{text = '‹ 𝖯𝗋𝗈𝖷 𝖬𝗎𝗌𝗂𝖼 ›',url="https://t.me/k6cbot"}}
}
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. msg.chat_id .. "&photo=https://t.me/k6cbot&caption=".. URL.escape(Text).."&photo=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end

----------------------------------------------------------------------------------------
if text == "الساعه" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ الساعه الان : ( "..os.date("%I:%M%p").." ) .*","md",true)  
end
if text == "شسمك" or text == "سنو اسمك" then
namet = {"حجي اسمي "..(redis:get(bot_id..":namebot") or "تريكس"),"يابه اسمي "..(redis:get(bot_id..":namebot") or "تريكس"),"اني لقميل "..(redis:get(bot_id..":namebot") or "تريكس"),(redis:get(bot_id..":namebot") or "تريكس").." اني"}
bot.sendText(msg.chat_id,msg.id,"*"..namet[math.random(#namet)].."*","md",true)  
end 
if text == "بوت" or text == (redis:get(bot_id..":namebot") or "تريكس") then
nameBot = {"ها حبي","ها سيد","كلي سيد","كلبي سيد","نعم تفضل ؟،","محتاج شي","عندي اسم وعيونك"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "التاريخ" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ التاريخ الان : ( "..os.date("%Y/%m/%d").." ) .*","md",true)  
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:GetBio") then
if text == 'البايو' or text == 'نبذتي' or text == 'بايو' then
bio = GetBio(msg.sender_id.user_id)
if bio and bio:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or 
bio and bio:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or 
bio and bio:match("[Tt].[Mm][Ee]/") or
bio and bio:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or 
bio and bio:match(".[Pp][Ee]") or 
bio and bio:match("[Hh][Tt][Tt][Pp][Ss]://") or 
bio and bio:match("[Hh][Tt][Tt][Pp]://") or 
bio and bio:match("[Ww][Ww][Ww].") or 
bio and bio:match(".[Cc][Oo][Mm]") or 
bio and bio:match("[Hh][Tt][Tt][Pp][Ss]://") or 
bio and bio:match("[Hh][Tt][Tt][Pp]://") or 
bio and bio:match("[Ww][Ww][Ww].") or 
bio and bio:match(".[Cc][Oo][Mm]") or 
bio and bio:match(".[Tt][Kk]") or 
bio and bio:match(".[Mm][Ll]") or 
bio and bio:match(".[Pp][Hh]") or 
bio and bio:match(".[Oo][Rr][Gg]") then 
bot.sendText(msg.chat_id,msg.id,"*⤈︙ "..text.. " الخاص بك يحتوي على رابط لا يمكن عرضه .*","md",true)  
return false
end
bot.sendText(msg.chat_id,msg.id,bio,"md",true)  
return false
end
end
if text == 'رفع المنشئ' or text == 'رفع المالك' then
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ البوت لا يمتلك صلاحيه*","md",true)  
return false
end
local info_ = bot.getSupergroupMembers(msg.chat_id, "Administrators", "*", 0, 200)
local list_ = info_.members
for k, v in pairs(list_) do
if info_.members[k].status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator", v.member_id.user_id)
return bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم "..text.." *","md",true)  
end
end
end
if text == 'المنشئ' or text == 'المالك' then
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ البوت لا يمتلك صلاحيه .*","md",true)  
return false
end
local info_ = bot.getSupergroupMembers(msg.chat_id, "Administrators", " .*", 0, 200)
local list_ = info_.members
for k, v in pairs(list_) do
if info_.members[k].status.luatele == "chatMemberStatusCreator" then
local UserInfo = bot.getUser(v.member_id.user_id)
if UserInfo.first_name == "" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ "..text.." حساب محذوف .*","md",true)  
return false
end
if UserInfo.username and UserInfo.username ~= "" then
t = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
u = '@'..UserInfo.username..''
ban = ' '..UserInfo.first_name..' '
else
t = '['..UserInfo.first_name..'](tg://user?id='..UserInfo.id..')'
u = 'لا يوجد'
end
sm = bot.getChatMember(msg.chat_id,UserInfo.id)
if sm.status.custom_title then
if sm.status.custom_title ~= "" then
custom = sm.status.custom_title
else
custom = 'لا يوجد'
end
end
if sm.status.luatele == "chatMemberStatusCreator"  then
gstatus = "المنشئ"
elseif sm.status.luatele == "chatMemberStatusAdministrator" then
gstatus = "المشرف"
else
gstatus = "العضو"
end
local photo = bot.getUserProfilePhotos(UserInfo.id)
if photo.total_count > 0 then
local TestText = "  *⤈︙ Name : *( "..(t).." *)*\n*⤈︙ User : *( "..(u).." *)*\n*⤈︙ Bio :* ["..GetBio(UserInfo.id).."]\n"
keyboardd = {}
keyboardd.inline_keyboard = {
{
{text = ban, url = "https://t.me/"..UserInfo.username..""},
},
}
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendPhoto?chat_id='..msg.chat_id..'&caption='..URL.escape(TestText)..'&photo='..photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id..'&reply_to_message_id='..msg_id..'&parse_mode=markdown&disable_web_page_preview=true&reply_markup='..JSON.encode(keyboardd))
else
bot.sendText(msg.chat_id,msg.id,"*⤈︙ الاسم : *( "..(t).." *)*\n*⤈︙ المعرف : *( "..(u).." *)*\n["..GetBio(UserInfo.id).."]","md",true)  
end
end
end
end
if text == 'المطور' or text == 'مطور البوت' then
local UserInfo = bot.getUser(sudoid)
if UserInfo.username and UserInfo.username ~= "" then
t = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
ban = ' '..UserInfo.first_name..' '
u = '@'..UserInfo.username..''
else
t = '['..UserInfo.first_name..'](tg://user?id='..UserInfo.id..')'
u = 'لا يوجد'
end
local photo = bot.getUserProfilePhotos(UserInfo.id)
if photo.total_count > 0 then
local TestText = "  *⤈︙ Name : *( "..(t).." *)*\n*⤈︙ User : *( "..(u).." *)*\n*⤈︙ Bio :* ["..GetBio(UserInfo.id).."]\n"
keyboardd = {}
keyboardd.inline_keyboard = {
{
{text = ban, url = "https://t.me/"..UserInfo.username..""},
},
}
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendPhoto?chat_id='..msg.chat_id..'&caption='..URL.escape(TestText)..'&photo='..photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id..'&reply_to_message_id='..msg_id..'&parse_mode=markdown&disable_web_page_preview=true&reply_markup='..JSON.encode(keyboardd))
else
bot.sendText(msg.chat_id,msg.id,"*⤈︙ الاسم : *( "..(t).." *)*\n*⤈︙ المعرف : *( "..(u).." *)*\n["..GetBio(UserInfo.id).."]","md",true)  
end
end
if text == 'مبرمج السورس' or text == 'مطور السورس' or text == 'المبرمج' then
local UserId_Info = bot.searchPublicChat("AYYYY")
if UserId_Info.id then
local UserInfo = bot.getUser(UserId_Info.id)
if UserInfo.username and UserInfo.username ~= "" then
t = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
ban = ' '..UserInfo.first_name..' '
u = '@'..UserInfo.username..''
else
t = '['..UserInfo.first_name..'](tg://user?id='..UserInfo.id..')'
u = 'لا يوجد'
end
local photo = bot.getUserProfilePhotos(UserId_Info.id)
if photo.total_count > 0 then
local TestText = "  *⤈︙ Name : *( "..(t).." *)*\n*⤈︙ User : *( "..(u).." *)*\n*⤈︙ Bio :* ["..GetBio(UserInfo.id).."]\n"
keyboardd = {}
keyboardd.inline_keyboard = {
{
{text = ban, url = "https://t.me/"..UserInfo.username..""},
},
}
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendPhoto?chat_id='..msg.chat_id..'&caption='..URL.escape(TestText)..'&photo='..photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id..'&reply_to_message_id='..msg_id..'&parse_mode=markdown&disable_web_page_preview=true&reply_markup='..JSON.encode(keyboardd))
else
bot.sendText(msg.chat_id,msg.id,"*⤈︙ الاسم : *( "..(t).." *)*\n*⤈︙ المعرف : *( "..(u).." *)*\n["..GetBio(UserInfo.id).."]","md",true)  
end
end
end
if Administrator(msg) then
if text == "تثبيت" and msg.reply_to_message_id ~= 0 then
if GetInfoBot(msg).PinMsg == false then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ البوت لا يمتلك صلاحيه تثبيت الرسائل .*',"md",true)  
return false
end
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم تثبيت الرساله بنجاح .*","md",true)
local Rmsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
bot.pinChatMessage(msg.chat_id,Rmsg.id,true)
end
end
if text == 'معلوماتي' or text == 'موقعي' or text == 'صلاحياتي' then
local UserInfo = bot.getUser(msg.sender_id.user_id)
local Statusm = bot.getChatMember(msg.chat_id,msg.sender_id.user_id).status.luatele
if Statusm == "chatMemberStatusCreator" then
StatusmC = 'منشئ'
elseif Statusm == "chatMemberStatusAdministrator" then
StatusmC = 'مشرف'
else
StatusmC = 'عضو'
end
if StatusmC == 'مشرف' then 
local GetMemberStatus = bot.getChatMember(msg.chat_id,msg.sender_id.user_id).status
if GetMemberStatus.can_change_info then
change_info = '✅️️' else change_info = '❌️'
end
if GetMemberStatus.can_delete_messages then
delete_messages = '✅️️' else delete_messages = '❌️'
end
if GetMemberStatus.can_invite_users then
invite_users = '✅️️' else invite_users = '❌️'
end
if GetMemberStatus.can_pin_messages then
pin_messages = '✅️️' else pin_messages = '❌️'
end
if GetMemberStatus.can_restrict_members then
restrict_members = '✅️️' else restrict_members = '❌️'
end
if GetMemberStatus.can_promote_members then
promote = '✅️️' else promote = '❌️'
end
if StatusmC == "عضو" then
PermissionsUser = ' '
else
PermissionsUser = '*\n⤈︙ صلاحياتك هي :\n *ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ *'..'\n⤈︙ تغيير المعلومات : '..change_info..'\n⤈︙ تثبيت الرسائل : '..pin_messages..'\n⤈︙ اضافه مستخدمين : '..invite_users..'\n⤈︙ مسح الرسائل : '..delete_messages..'\n⤈︙ حظر المستخدمين : '..restrict_members..'\n⤈︙ اضافه المشرفين : '..promote..'\n\n*'
end
end
local UserId = msg.sender_id.user_id
local Get_Rank =(Get_Rank(msg.sender_id.user_id,msg.chat_id))
local messageC =(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":message") or 1)
local EditmessageC =(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Editmessage") or 0)
local Total_ms =Total_message((redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":message") or 1))
if UserInfo.username and UserInfo.username ~= "" then
UserInfousername = '@'..UserInfo.username
else
UserInfousername = 'لا يوجد'
end
bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ ايديك : '..UserId..'\n⤈︙ معرفك : '..UserInfousername..'\n⤈︙ ‍رتبتك : '..Get_Rank..'\n⤈︙ موقعك : '..StatusmC..'\n⤈︙ رسائلك : '..messageC..'\n⤈︙ تعديلاتك : '..EditmessageC..'\n⤈︙ تفاعلك : '..Total_ms..'*'..(PermissionsUser or '') ,"md",true) 
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:id") then
if text == "ايدي" and msg.reply_to_message_id == 0 then
local Get_Rank =(Get_Rank(msg.sender_id.user_id,msg.chat_id))
local messageC =(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":message") or 1)
local gameC =(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game") or 0)
local Addedmem =(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Addedmem") or 0)
local EditmessageC =(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Editmessage") or 0)
local Total_ms =Total_message((redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":message") or 1))
local photo = bot.getUserProfilePhotos(msg.sender_id.user_id)
local TotalPhoto = photo.total_count or 0
local UserInfo = bot.getUser(msg.sender_id.user_id)
local Texting = {
'*⤈︙ *صورتك تخبل حيلي لتغيرها 💝 .',
"*⤈︙ *صارلك شكد مخلي هل صوره ؟ .",
"*⤈︙ *وف عمري صورتك ضيم 💗😮‍💨 .",
"*⤈︙ *يخي صورتك تموت ورب 😔🤍 .",
"*⤈︙ *ايع غيرها قديمه يالكرنج 😂😔 .",
"*⤈︙ *عمري الحلو مالتي انت 💘 .",
}
local Description = Texting[math.random(#Texting)]
if UserInfo.username and UserInfo.username ~= "" then
UserInfousername ="[@"..UserInfo.username.."]"
else
UserInfousername = 'لا يوجد'
end
if redis:get(bot_id..":"..msg.chat_id..":id") then
theId = redis:get(bot_id..":"..msg.chat_id..":id") 
theId = theId:gsub('#AddMem',Addedmem) 
theId = theId:gsub('#game',gameC) 
theId = theId:gsub('#id',msg.sender_id.user_id) 
theId = theId:gsub('#username',UserInfousername) 
theId = theId:gsub('#msgs',messageC) 
theId = theId:gsub('#edit',EditmessageC) 
theId = theId:gsub('#stast',Get_Rank) 
theId = theId:gsub('#auto',Total_ms) 
theId = theId:gsub('#Description',Description) 
theId = theId:gsub('#photos',TotalPhoto) 
else
theId = Description.."\n*⤈︙ الايدي : (* `"..msg.sender_id.user_id.."`* ) .\n⤈︙ المعرف :* ( "..UserInfousername.." ) .\n⤈︙ *الرتبه : (  "..Get_Rank.." ) .\n⤈︙ تفاعلك : (  "..Total_ms.." ) .\n⤈︙ عدد الرسائل : ( "..messageC.." ) .\n⤈︙ عدد السحكات : ( "..EditmessageC.." ) .\n⤈︙ عدد صورك : ( "..TotalPhoto.."* ) ."
end
if redis:get(bot_id..":"..msg.chat_id..":settings:id:ph") then
bot.sendText(msg.chat_id,msg.id,theId,"md",true) 
return false
end
if photo.total_count > 0 then
return bot.sendPhoto(msg.chat_id, msg.id, photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id,theId,"md")
else
return bot.sendText(msg.chat_id,msg.id,theId,"md",true) 
end
end
end

if text == 'تاك مخفي' or text == 'منشن مخفي' and Administrator(msg) then
local Info = bot.searchChatMembers(msg.chat_id, "*", 100)
local members = Info.members
ls = '\n*⤈︙ قائمه التاك المخفي .\n  ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ *\n'
for k, v in pairs(members) do
local Textingt = {"0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0",}
local Descriptiont = Textingt[math.random(#Textingt)]
ls = ls..' ['..Descriptiont..'](tg://user?id='..v.member_id.user_id..')\n'
end
bot.sendText(msg.chat_id,msg.id,ls,"md",true)  
end

if text and text:match('^ايدي @(%S+)$') or text and text:match('^كشف @(%S+)$') then
local UserName = text:match('^ايدي @(%S+)$') or text:match('^كشف @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر لقناه او كروب تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
sm = bot.getChatMember(msg.chat_id,UserId_Info.id)
if sm.status.luatele == "chatMemberStatusCreator"  then
gstatus = "المالك الاساسي"
elseif sm.status.luatele == "chatMemberStatusAdministrator" then
gstatus = "مشرف"
else
gstatus = "عضو"
end
bot.sendText(msg.chat_id,msg.id,"*⤈︙ الايدي : *( `"..(UserId_Info.id).."` *)*\n*⤈︙ المعرف : *( [@"..(UserName).."] *)*\n*⤈︙ الرتبه : *( `"..(Get_Rank(UserId_Info.id,msg.chat_id)).."` *)*\n*⤈︙ الموقع : *( `"..(gstatus).."` *)*\n*⤈︙ عدد الرسائل : *( `"..(redis:get(bot_id..":"..msg.chat_id..":"..UserId_Info.id..":message") or 1).."` *)*" ,"md",true)  
end
if text == 'ايدي' or text == 'كشف'  and msg.reply_to_message_id ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender_id.user_id)
if UserInfo.username and UserInfo.username ~= "" then
uame = '@'..UserInfo.username
else
uame = 'لا يوجد'
end
sm = bot.getChatMember(msg.chat_id,Remsg.sender_id.user_id)
if sm.status.luatele == "chatMemberStatusCreator"  then
gstatus = "المالك الاساسي"
elseif sm.status.luatele == "chatMemberStatusAdministrator" then
gstatus = "مشرف"
else
gstatus = "عضو"
end
bot.sendText(msg.chat_id,msg.id,"*⤈︙ الايدي : *( `"..(Remsg.sender_id.user_id).."` *)*\n*⤈︙ المعرف : *( ["..(uame).."] *)*\n*⤈︙ الرتبه : *( `"..(Get_Rank(Remsg.sender_id.user_id,msg.chat_id)).."` *)*\n*⤈︙ الموقع : *( `"..(gstatus).."` *)*\n*⤈︙ عدد الرسائل : *( `"..(redis:get(bot_id..":"..msg.chat_id..":"..Remsg.sender_id.user_id..":message") or 1).."` *)*" ,"md",true)  
end
if text and text:match('^كشف (%d+)$') or text and text:match('^ايدي (%d+)$') then
local UserName = text:match('^كشف (%d+)$') or text:match('^ايدي (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if UserInfo.username and UserInfo.username ~= "" then
uame = '@'..UserInfo.username
else
uame = 'لا يوجد'
end
sm = bot.getChatMember(msg.chat_id,UserName)
if sm.status.luatele == "chatMemberStatusCreator"  then
gstatus = "المالك الاساسي"
elseif sm.status.luatele == "chatMemberStatusAdministrator" then
gstatus = "مشرف"
else
gstatus = "عضو"
end
bot.sendText(msg.chat_id,msg.id,"*⤈︙ الايدي : *( `"..(UserName).."` *)*\n*⤈︙ المعرف : *( ["..(uame).."] *)*\n*⤈︙ الرتبه : *( `"..(Get_Rank(UserName,msg.chat_id)).."` *)*\n*⤈︙ الموقع : *( `"..(gstatus).."` *)*\n*⤈︙ عدد الرسائل : *( `"..(redis:get(bot_id..":"..msg.chat_id..":"..UserName..":message") or 1).."` *)*" ,"md",true)  
end
if text == 'رتبتي' then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ رتبتك : *( `"..(Get_Rank(msg.sender_id.user_id,msg.chat_id)).."` *)*","md",true)  
return false
end
if text == 'سحكاتي' or text == 'تعديلاتي' then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عدد سحكاتك : *( `"..(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Editmessage") or 0).."` *)*","md",true)  
return false
end
if text == 'مسح سحكاتي' or text == 'مسح تعديلاتي' then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ تم مسح جميع سحكاتك .*',"md",true)   
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Editmessage")
return false
end
if text == 'جهاتي' or text == 'اضافاتي' then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عدد جهاتك : *( `"..(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Addedmem") or 0).."` *)*","md",true)  
return false
end
if text ==("مسح") and Administrator(msg) and tonumber(msg.reply_to_message_id) > 0 then
if GetInfoBot(msg).Delmsg == false then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ ليس لدي صلاحيه حذف رسائل .*',"md",true)  
return false
end
bot.deleteMessages(msg.chat_id,{[1]= msg.reply_to_message_id})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end   
if text == 'مسح جهاتي' or text == 'مسح اضافاتي' then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ تم مسح جميع جهاتك .*',"md",true)   
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Addedmem")
return false
end
if text == "منو ضافني" and not redis:get(bot_id..":"..msg.chat_id..":settings:addme") then
if bot.getChatMember(msg.chat_id,msg.sender_id.user_id).status.luatele == "chatMemberStatusCreator" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ انت منشئ المجموعه. *","md",true) 
return false
end
addby = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":AddedMe")
if addby then 
UserInfo = bot.getUser(addby)
Name = '['..UserInfo.first_name..'](tg://user?id='..addby..')'
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم اضافتك بواسطه  : ( *"..(Name).." *)*","md",true)  
else
bot.sendText(msg.chat_id,msg.id,"*⤈︙ قد قمت بالانضمام عبر الرابط .*","md",true) 
return false
end
end
if Constructor(msg) then
if text and text:match("^اضف نقاط (%d+)$") and tonumber(msg.reply_to_message_id) ~= 0 then
if not redis:get(bot_id..":game"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اضف نقاط معطل بواسطه المشرفين .","md",true)
end
local Num = text:match("^اضف نقاط (%d+)$")
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender_id.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
redis:incrby(bot_id..":"..msg.chat_id..":"..Remsg.sender_id.user_id..":game",string.match(text:match("^اضف نقاط (%d+)$"), "(%d+)"))  
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم اضافه ( "..string.match(text:match("^اضف نقاط (%d+)$"), "(%d+)").." ) رساله له .*").yu,"md",true)
return false
end
if redis:get(bot_id..":"..msg.chat_id..":settings:game:"..msg.sender_id.user_id) then
if text then
if text and text:match('^@(%S+)$') then
local UserName = text:match('^(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
redis:incrby(bot_id..":"..msg.chat_id..":"..UserId_Info.id..":game",redis:get(bot_id..":"..msg.chat_id..":settings:game:"..msg.sender_id.user_id))  
elseif text and text:match('^(%d+)$') then
local UserName = text:match('^(%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ الايدي ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
redis:incrby(bot_id..":"..msg.chat_id..":"..UserName..":game",redis:get(bot_id..":"..msg.chat_id..":settings:game:"..msg.sender_id.user_id))  
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم اضافه ( "..redis:get(bot_id..":"..msg.chat_id..":settings:game:"..msg.sender_id.user_id).." ) رساله له .*").yu,"md",true)
redis:del(bot_id..":"..msg.chat_id..":settings:game:"..msg.sender_id.user_id)
return false
end
end
if text and text:match("^اضف نقاط (%d+)$") and tonumber(msg.reply_to_message_id) == 0 then
redis:setex(bot_id..":"..msg.chat_id..":settings:game:"..msg.sender_id.user_id,360,string.match(text:match("^اضف نقاط (%d+)$"), "(%d+)")) 
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسل معرف او ايدي الشخص الان .*","md",true)   
end
if text and text:match("^اضف رسائل (%d+)$") and tonumber(msg.reply_to_message_id) ~= 0 then
if not redis:get(bot_id..":settings:game:"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اضف رسائل معطل بواسطه المشرفين .","md",true)
end
local Num = text:match("^اضف رسائل (%d+)$")
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender_id.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
redis:incrby(bot_id..":"..msg.chat_id..":"..Remsg.sender_id.user_id..":message",string.match(text:match("^اضف رسائل (%d+)$"), "(%d+)"))  
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم اضافه ( "..string.match(text:match("^اضف رسائل (%d+)$"), "(%d+)").." ) رساله له .*").yu,"md",true)
return false
end
if redis:get(bot_id..":"..msg.chat_id..":settings:addmsg:"..msg.sender_id.user_id) then
if text then
if text and text:match('^@(%S+)$') then
local UserName = text:match('^(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
redis:incrby(bot_id..":"..msg.chat_id..":"..UserId_Info.id..":message",redis:get(bot_id..":"..msg.chat_id..":settings:addmsg:"..msg.sender_id.user_id))  
redis:del(bot_id..":"..msg.chat_id..":settings:addmsg:"..msg.sender_id.user_id)
elseif text and text:match('^(%d+)$') then
local UserName = text:match('^(%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ الايدي ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
redis:incrby(bot_id..":"..msg.chat_id..":"..UserName..":message",redis:get(bot_id..":"..msg.chat_id..":settings:addmsg:"..msg.sender_id.user_id))  
redis:del(bot_id..":"..msg.chat_id..":settings:addmsg:"..msg.sender_id.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم اضافه ( "..redis:get(bot_id..":"..msg.chat_id..":settings:addmsg:"..msg.sender_id.user_id).." ) رساله له .*").yu,"md",true)
redis:del(bot_id..":"..msg.chat_id..":settings:addmsg:"..msg.sender_id.user_id)
return false
end
end
if text and text:match("^اضف رسائل (%d+)$") and tonumber(msg.reply_to_message_id) == 0 then
redis:setex(bot_id..":"..msg.chat_id..":settings:addmsg:"..msg.sender_id.user_id,360,string.match(text:match("^اضف رسائل (%d+)$"), "(%d+)")) 
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسل معرف او ايدي الشخص الان .*","md",true)   
end
end --- Constructor
if msg then
local GetMsg = redis:incr(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":message") 
redis:hset(bot_id..':User:Count:'..msg.chat_id,msg.sender_id.user_id,GetMsg)
local UserInfo = bot.getUser(msg.sender_id.user_id)
if UserInfo.first_name then
NameLUser = UserInfo.first_name
NameLUser = NameLUser:gsub("]","")
NameLUser = NameLUser:gsub("[[]","")
redis:hset(bot_id..':User:Name:'..msg.chat_id,msg.sender_id.user_id,NameLUser)
end
end
if text == 'رسائلي' then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عدد رسائلك : *( `"..(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":message") or 1).."` *)*","md",true)  
return false
end
if text == 'مسح رسائلي' then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ تم مسح جميع رسائلك .*',"md",true)   
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":message")
return false
end
if text == 'نقاطي' or text == 'مجوهراتي' then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عدد نقاطك : *( `"..(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game") or 0).."` *)*","md",true)  
return false
end
if text and text:match("^بيع نقاطي (%d+)$") then  
local end_n = text:match("^بيع نقاطي (%d+)$")
if tonumber(end_n) == tonumber(0) then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ لا استطيع البيع اقل من 1*","md",true)  
return false 
end
if tonumber(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game")) == tonumber(0) then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ليس لديك جواهر من الالعاب \n⤈︙ اذا كنت تريد ربح الجواهر \n⤈︙ ارسل الالعاب وابدأ اللعب !*","md",true)  
else
local nb = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game")
if tonumber(end_n) > tonumber(nb) then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ليس لديك جواهر بهاذا العدد \n⤈︙ لزيادة مجوهراتك في اللعبه \n⤈︙ ارسل الالعاب وابدأ اللعب !*","md",true)  
return false
end
local end_d = string.match((end_n * 50), "(%d+)") 
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم خصم* *~ { "..end_n.." }* *من مجوهراتك* \n*⤈︙ وتم اضافة* *~ { "..end_d.." }* *الى رسائلك*","md",true)  
redis:decrby(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game",end_n)  
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":message",end_d)  
end
return false 
end
if text == 'مسح نقاطي' or text == 'مسح مجوهراتي' then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ تم مسح جميع نقاطك .*',"md",true)   
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game")
return false
end
if text == 'ايديي' then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ايديك : *( `"..msg.sender_id.user_id.."` *)*","md",true)  
return false
end
if text == 'اسمي' then
firse = bot.getUser(msg.sender_id.user_id).first_name
if firse and firse:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or 
firse and firse:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or 
firse and firse:match("[Tt].[Mm][Ee]/") or
firse and firse:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or 
firse and firse:match(".[Pp][Ee]") or 
firse and firse:match("[Hh][Tt][Tt][Pp][Ss]://") or 
firse and firse:match("[Hh][Tt][Tt][Pp]://") or 
firse and firse:match("[Ww][Ww][Ww].") or 
firse and firse:match(".[Cc][Oo][Mm]") or 
firse and firse:match("[Hh][Tt][Tt][Pp][Ss]://") or 
firse and firse:match("[Hh][Tt][Tt][Pp]://") or 
firse and firse:match("[Ww][Ww][Ww].") or 
firse and firse:match(".[Cc][Oo][Mm]") or 
firse and firse:match(".[Tt][Kk]") or 
firse and firse:match(".[Mm][Ll]") or 
firse and firse:match(".[Oo][Rr][Gg]") then 
bot.sendText(msg.chat_id,msg.id,"*⤈︙ الاسم الخاص بك يحتوي على رابط لا يمكن عرضه .*","md",true)  
return false
end
bot.sendText(msg.chat_id,msg.id," *⤈︙ اسمك : *( "..bot.getUser(msg.sender_id.user_id).first_name.." *)*","md",true)  
return false
end
if text == ("مسح الطليان") then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص الادمن* ',"md",true)  
end
local numtsh = redis:scard(bot_id..'bot_idath'..msg.chat_id)
if numtsh ==0 then  
return bot.sendText(msg.chat_id,msg.id, "⤈︙ لا يوجد طليان هنا " )
end
redis:del(bot_id..'bot_idath'..msg.chat_id)
return bot.sendText(msg.chat_id,msg.id, "⤈︙ أهلا عزيزي \n⤈︙ تم مسح ("..numtsh..") من الطليان ")
elseif text == ("مسح البقر") then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص الادمن* ',"md",true)  
end
local numtsh = redis:scard(bot_id..'klp'..msg.chat_id)
if numtsh ==0 then  
return bot.sendText(msg.chat_id,msg.id, "⤈︙ لا يوجد بقر هنا " )
end
redis:del(bot_id..'klp'..msg.chat_id)
return bot.sendText(msg.chat_id,msg.id, "⤈︙ أهلا عزيزي \n⤈︙ تم مسح ("..numtsh..") من البقر ")
elseif text == ("مسح الكلاب") then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص الادمن * ',"md",true)  
end
local numtsh = redis:scard(bot_id..'donke'..msg.chat_id)
if numtsh ==0 then  
return bot.sendText(msg.chat_id,msg.id, "⤈︙ لا يوجد كلاب هنا " )
end
redis:del(bot_id..'donke'..msg.chat_id)
return bot.sendText(msg.chat_id,msg.id, "⤈︙ أهلا عزيزي \n⤈︙ تم مسح ("..numtsh..") من الكلاب ")
elseif text == ("مسح الاغبياء") then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص الادمن* ',"md",true)  
end
local numtsh = redis:scard(bot_id..'zahf'..msg.chat_id)
if numtsh ==0 then  
return bot.sendText(msg.chat_id,msg.id, "⤈︙ لا يوجد اغبياء هنا " )
end
redis:del(bot_id..'zahf'..msg.chat_id)
return bot.sendText(msg.chat_id,msg.id, "⤈︙ أهلا عزيزي \n⤈︙ تم مسح ("..numtsh..") من الاغبياء ")
elseif text == ("مسح المنظفين") then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص الادمن* ',"md",true)  
end
local numtsh = redis:scard(bot_id..'klpe'..msg.chat_id)
if numtsh ==0 then  
return boy.sendText(msg.chat_id,msg.id, "⤈︙ لا يوجد " )
end
redis:del(bot_id..'klpe'..msg.chat_id)
return bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم مسح ( "..numtsh.." ) من المنظفين .*","md",true)
elseif text == ("مسح الزوجات") then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص الادمن* ',"md",true)  
end
local numtsh = redis:scard(bot_id..'mrtee'..msg.chat_id)
if numtsh ==0 then  
return bot.sendText(msg.chat_id,msg.id, "⤈︙ لا يوجد زوجات بالكروب " )
end
redis:del(bot_id..'mrtee'..msg.chat_id)
return bot.sendText(msg.chat_id,msg.id, "⤈︙ أهلا عزيزي \n⤈︙ تم مسح ("..numtsh..") من قائمه الزوجات ")
end

if text == 'ملصق' and tonumber(msg.reply_to_message_id) > 0 then
local data = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if data.content.photo then
if data.content.photo.sizes[1].photo.remote.id then
idPhoto = data.content.photo.sizes[1].photo.remote.id
elseif data.content.photo.sizes[2].photo.remote.id then
idPhoto = data.content.photo.sizes[2].photo.remote.id
elseif data.content.photo.sizes[3].photo.remote.id then
idPhoto = data.content.photo.sizes[3].photo.remote.id
end
local File = json:decode(https.request('https://api.telegram.org/bot' .. Token .. '/getfile?file_id='..idPhoto) ) 
local Name_File = download('https://api.telegram.org/file/bot'..Token..'/'..File.result.file_path, './'..msg.id..'.webp') 
bot.sendSticker(msg.chat_id, msg.id, Name_File)
os.execute('rm -rf '..Name_File) 
else
bot.sendText(msg.chat_id,msg.id,'⤈︙ هذه ليست صورة')
end
end
if text == 'صوره' and tonumber(msg.reply_to_message_id) > 0 then
local data = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if data.content.sticker then    
local File = json:decode(https.request('https://api.telegram.org/bot' .. Token .. '/getfile?file_id='..data.content.sticker.sticker.remote.id) ) 
local Name_File = download('https://api.telegram.org/file/bot'..Token..'/'..File.result.file_path, './'..msg.id..'.jpg') 
bot.sendPhoto(msg.chat_id, msg.id, Name_File,'')
os.execute('rm -rf '..Name_File) 
else
bot.sendText(msg.chat_id,msg.id,'⤈︙ هذا ليس ملصق')
end
end
if text == 'بصمه' and tonumber(msg.reply_to_message_id) > 0 then
local data = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if data.content.audio then    
local File = json:decode(https.request('https://api.telegram.org/bot' .. Token .. '/getfile?file_id='..data.content.audio.audio.remote.id) ) 
local Name_File = download('https://api.telegram.org/file/bot'..Token..'/'..File.result.file_path, './'..msg.id..'.ogg') 
bot.sendVoiceNote(msg.chat_id, msg.id, Name_File, '', 'md')
os.execute('rm -rf '..Name_File) 
else
bot.sendText(msg.chat_id,msg.id,'⤈︙ هذا ليس ملف صوتي')
end
end
if text == 'صوت' and tonumber(msg.reply_to_message_id) > 0 then
local data = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if data.content.voice_note then
local File = json:decode(https.request('https://api.telegram.org/bot' .. Token .. '/getfile?file_id='..data.content.voice_note.voice.remote.id) ) 
local Name_File = download('https://api.telegram.org/file/bot'..Token..'/'..File.result.file_path, msg.id..'.mp3') 
bot.sendAudio(msg.chat_id, msg.id, Name_File, '', "md") 
os.execute('rm -rf '..Name_File) 
else
bot.sendText(msg.chat_id,msg.id,' ⤈︙ هذا ليس بصمه')
end
end
if text == 'mp3' and tonumber(msg.reply_to_message_id) > 0 then
local data = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if data.content.video then
local File = json:decode(https.request('https://api.telegram.org/bot' .. Token .. '/getfile?file_id='..data.content.video.video.remote.id) ) 
local Name_File = download('https://api.telegram.org/file/bot'..Token..'/'..File.result.file_path, msg.id..'.mp3') 
return bot.sendAudio(msg.chat_id, msg.id, Name_File, '', "md") 
--os.execute('rm -rf '..Name_File) 
else
bot.sendText(msg.chat_id,msg.id,'⤈︙ هذا ليس فيديو')
end
end
if text == 'متحركه' and tonumber(msg.reply_to_message_id) > 0 then
local data = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if data.content.video then
local File = json:decode(https.request('https://api.telegram.org/bot' .. Token .. '/getfile?file_id='..data.content.video.video.remote.id) ) 
local Name_File = download('https://api.telegram.org/file/bot'..Token..'/'..File.result.file_path, msg.id..'.gif.mp4') 
bot.sendAnimation(msg.chat_id,msg.id, Name_File, '', 'md')
--os.execute('rm -rf '..Name_File) 
else
bot.sendText(msg.chat_id,msg.id,'⤈︙ هذا ليس فيديو')
end
end

if text and text:match("^انطق (.*)$") then
local UrlAntk = https.request('https://apiabs.ml/Antk.php?abs='..URL.escape(text:match("^انطق (.*)$")))
Antk = JSON.decode(UrlAntk)
if UrlAntk.ok ~= false then
uuu = download("https://translate"..Antk.result.google..Antk.result.code.."UTF-8"..Antk.result.utf..Antk.result.translate.."&tl=ar-IN",'./'..Antk.result.translate..'.mp3') 
bot.sendAudio(msg.chat_id, msg.id, uuu) 
os.execute('rm -rf ./'..Antk.result.translate..'.mp3') 
end
end

if text == "نسبه الحب" or text == "نسبه حب" and msg.reply_to_message_id ~= 0 then
if not redis:get(bot_id.."nsab"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ اوامر النسب معطلة من قبل المشرفين","md",true)
end
redis:set(bot_id..":"..msg.sender_id.user_id..":lov_Bots"..msg.chat_id,"sendlove")
hggg = '⤈︙ الان ارسل اسمك واسم الشخص الثاني'
bot.sendText(msg.chat_id,msg.id,hggg) 
return false
end

if text == "جمالي" or text == 'نسبه جمالي' then
if not redis:get(bot_id.."jmal"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اوامر جمالي معطله بواسطه المشرفين .","md",true)
end
local photo = bot.getUserProfilePhotos(msg.sender_id.user_id)
if developer(msg) then
if photo.total_count > 0 then
return bot.sendPhoto(msg.chat_id, msg.id, photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id,"*اجمل مطور شفته بحياتي ❤*", "md")
else
return bot.sendText(msg.chat_id,msg.id,'*⤈︙ لا توجد صوره في حسابك .*',"md",true) 
end
else
if photo.total_count > 0 then
local nspp = {"10","20","30","35","75","34","66","82","23","19","55","80","63","32","27","89","99","98","79","100","8","3","6","0",}
local rdbhoto = nspp[math.random(#nspp)]
return bot.sendPhoto(msg.chat_id, msg.id, photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id,"*نسبة جمالك هي "..rdbhoto.."% *", "md")
else
return bot.sendText(msg.chat_id,msg.id,'*⤈︙ لا توجد صوره في حسابك .*',"md",true) 
end
end
end
if text == "نسبه الغباء" or text == "نسبه الغباء" and msg.reply_to_message_id ~= 0 then
if not redis:get(bot_id.."nsab"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ اوامر النسب معطلة من قبل المشرفين","md",true)
end
redis:set(bot_id..":"..msg.sender_id.user_id..":lov_Bottts"..msg.chat_id,"sendlove")
hggg = '⤈︙ الان ارسل اسم الشخص '
bot.sendText(msg.chat_id,msg.id,hggg) 
return false
end
if text == "نسبه الذكاء" or text == "نسبه الذكاء" and msg.reply_to_message_id ~= 0 then
if not redis:get(bot_id.."nsab"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ اوامر النسب معطلة من قبل المشرفين","md",true)
end
redis:set(bot_id..":"..msg.sender_id.user_id..":lov_Botttuus"..msg.chat_id,"sendlove")
hggg = '⤈︙ الان ارسل اسم الشخص '
bot.sendText(msg.chat_id,msg.id,hggg) 
return false
end
if text == "نسبه الكره" or text == "نسبه كره" and msg.reply_to_message_id ~= 0 then
if not redis:get(bot_id.."nsab"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ اوامر النسب معطلة من قبل المشرفين","md",true)
end
redis:set(bot_id..":"..msg.sender_id.user_id..":krh_Bots"..msg.chat_id,"sendkrhe")
hggg = '⤈︙ الان ارسل اسمك واسم الشخص الثاني '
bot.sendText(msg.chat_id,msg.id,hggg) 
return false
end
if text == "نسبه الرجوله" or text == "نسبه الرجولة" and msg.reply_to_message_id ~= 0 then
if not redis:get(bot_id.."nsab"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ اوامر النسب معطلة من قبل المشرفين","md",true)
end
redis:set(bot_id..":"..msg.sender_id.user_id..":rjo_Bots"..msg.chat_id,"sendrjoe")
hggg = '⤈︙ الان ارسل اسم الشخص :'
bot.sendText(msg.chat_id,msg.id,hggg) 
return false
end
if text == "نسبه الانوثه" or text == "نسبه انوثه" and msg.reply_to_message_id ~= 0 then
if not redis:get(bot_id.."nsab"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ اوامر النسب معطلة من قبل المشرفين","md",true)
end
redis:set(bot_id..":"..msg.sender_id.user_id..":ano_Bots"..msg.chat_id,"sendanoe")
hggg = '⤈︙ الان ارسل اسم الشخص :'
bot.sendText(msg.chat_id,msg.id,hggg) 
return false
end
if text == "معرفي" or text == "يوزري" then
local ban = bot.getUser(msg.sender_id.user_id)
if ban.username then
banusername = '[@'..ban.username..']'
else
banusername = 'لا يوجد لديك يوزر'
end
return bot.sendText(msg.chat_id,msg.id,banusername,"md",true) 
end

if text == 'نادي المبرمج' or text == 'نادي مطور السورس' or text == 'نادي مبرمج السورس' or text == 'نادي المطور' then  
bot.sendText(msg.chat_id,msg.id,"⤈︙ تم ارسال طلبك الى فريق سورس تريكس سوف يتم الرد عليك قريباً .")
local Get_Chat = bot.getChat(msg.chat_id)
local Info_Chats = bot.getSupergroupFullInfo(msg.chat_id)
local bains = bot.getUser(msg.sender_id.user_id)
if bains.first_name then
klajq = '*['..bains.first_name..'](tg://user?id='..bains.id..')*'
else
klajq = 'لا يوجد'
end
if bains.username then
basgk = ''..bains.username..' '
else
basgk = 'لا يوجد'
end
local czczh = ''..bains.first_name..''
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = czczh, url = "https://t.me/"..bains.username..""},
},
{
{text = Get_Chat.title, url = Info_Chats.invite_link.invite_link}, 
},
}
}
bot.sendText(1497373149,0,'*\n⤈︙ مرحباً عزيزي مبرمج السورس \nشخص ما يحتاج مساعدتك\nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ \n⤈︙ اسمه : '..klajq..' \n⤈︙ ايديه : '..msg.sender_id.user_id..'\n⤈︙ يوزره : @'..basgk..'\n⤈︙ الوقت : '..os.date("%I:%M %p")..'\n⤈︙ التاريخ : '..os.date("%Y/%m/%d")..'*',"md",false, false, false, false, reply_markup)
end
if text == "تتزوجني" then
if not redis:get(bot_id.."ttzog"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ الزواج معطل من قبل المشرفين","md",true)
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local ban = bot.getUser(Message_Reply.sender_id.user_id)
local bain = bot.getUser(msg.sender_id.user_id)
if ban.first_name then
baniusername = '*طلبت : *['..bain.first_name..'](tg://user?id='..bain.id..')*\nالزواج من : *['..ban.first_name..'](tg://user?id='..ban.id..')*\nهل العريس موافق ؟\n*'
else
baniusername = 'لا يوجد'
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '‹ موافق ›', data = Message_Reply.sender_id.user_id..'/zog3'},{text = '‹ رفض ›', data = Message_Reply.sender_id.user_id..'/zog4'}, 
},
{
{text = '‹ اخفاء ›', data = msg.sender_id.user_id..'/delAmr'}, 
},
}
}
return bot.sendText(msg.chat_id,msg.id,baniusername,"md",false, false, false, false, reply_markup)
end
if text == "تتزوجيني"  then
if not redis:get(bot_id.."ttzog"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ تتزوجيني معطله بواسطه المشرفين .","md",true)
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local ban = bot.getUser(Message_Reply.sender_id.user_id)
local bain = bot.getUser(msg.sender_id.user_id)
if ban.first_name then
baniusername = '*طلب *['..bain.first_name..'](tg://user?id='..bain.id..')*\nالزواج من *['..ban.first_name..'](tg://user?id='..ban.id..')*\nهل الزوجة موافقة ؟\n*'
else
baniusername = 'لا يوجد'
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '‹ موافقه ›', data = Message_Reply.sender_id.user_id..'/zog1'},{text = '‹ رفض ›', data = Message_Reply.sender_id.user_id..'/zog2'}, 
},
{
{text = '‹ اخفاء ›', data = msg.sender_id.user_id..'/delAmr'}, 
},
}
}
return bot.sendText(msg.chat_id,msg.id,baniusername,"md",false, false, false, false, reply_markup)
end

if text == "صورتي" or text == "افتاري" then
if not redis:get(bot_id.."aftare"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ صورتي معطله بواسطه المشرفين .","md",true)
end
local photo = bot.getUserProfilePhotos(msg.sender_id.user_id)
local ban = bot.getUser(msg.sender_id.user_id)
local ban_ns = ''
if photo.total_count > 0 then
data = {} 
data.inline_keyboard = {
{
{text = '‹ الصوره التاليه ›', callback_data= msg.sender_id.user_id..'/ban1'}, 
},
{
{text = '‹ اخفاء ›', callback_data= msg.sender_id.user_id..'/delAmr'}, 
},
}
local msgg = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. msg.chat_id .. "&photo="..photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id.."&caption=".. URL.escape(ban_ns).."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(data))
end
end

if text== "رفع طلي"  and msg.reply_to_message_id then
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الترفيه معطل من قبل المشرفين","md",true)
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
redis:sadd(bot_id.."bot_idath"..msg.chat_id, Message_Reply.sender_id.user_id)
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اهــلا عزيزي\n⤈︙ تم رفع العضو طلي \n⤈︙ وتمت اضافته إلى قائمه الطليان")
elseif text== "تنزيل طلي"  and msg.reply_to_message_id then    
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الترفيه معطل من قبل المشرفين","md",true)
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
redis:srem(bot_id.."bot_idath"..msg.chat_id, Message_Reply.sender_id.user_id)
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اهــلا عزيزي\n⤈︙ تم تنزيل العضو من طليان المجموعه")
elseif text== "رفع بقره"  and msg.reply_to_message_id then    
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الترفيه معطل من قبل المشرفين","md",true)
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
redis:sadd(bot_id.."klp"..msg.chat_id, Message_Reply.sender_id.user_id)
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اهــلا عزيزي\n⤈︙ تم رفع العضو بقرة  🐄\n⤈︙ وتمت إضافته إلى قائمه البقر️")
elseif text== "رفع جلب"  and msg.reply_to_message_id then    
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الترفيه معطل من قبل المشرفين","md",true)
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
redis:sadd(bot_id.."donke"..msg.chat_id, Message_Reply.sender_id.user_id)
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اهــلا عزيزي\n⤈︙ تم رفع العضو كلب 🐕‍🦺\n⤈︙ وتمت إضافته إلى قائمه الجلاب")
elseif text== "تنزيل جلب"  and msg.reply_to_message_id then    
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الترفيه معطل من قبل المشرفين","md",true)
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
redis:srem(bot_id.."donke"..msg.chat_id, Message_Reply.sender_id.user_id)
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اهــلا عزيزي\n⤈︙ تم تنزيل العضو من قائمة الجلاب️")
elseif text== "تنزيل بقره"  and msg.reply_to_message_id then 
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الترفيه معطل من قبل المشرفين","md",true)
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
redis:srem(bot_id.."klp"..msg.chat_id, Message_Reply.sender_id.user_id)
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اهــلا عزيزي \n⤈︙ تم تنزيل العضو من قائمه البقر")
elseif text== "تنزيل غبي"  and msg.reply_to_message_id then    
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الترفيه معطل من قبل المشرفين","md",true)
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
redis:srem(bot_id.."zahf"..msg.chat_id, Message_Reply.sender_id.user_id)
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اهــلا عزيزي\n⤈︙ تم تنزيل من قائمه الاغبياء️")
elseif text== "رفع غبي"  and msg.reply_to_message_id then    
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الترفيه معطل من قبل المشرفين","md",true)
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
redis:srem(bot_id.."mrtee"..msg.chat_id, Message_Reply.sender_id.user_id)
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اهــلا عزيزي\n⤈︙ تم تنزيل العضو زوجتك️")
elseif text== "رفع قرد"  and msg.reply_to_message_id then    
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الترفيه معطل من قبل المشرفين","md",true)
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
redis:sadd(bot_id.."QERD"..msg.chat_id, Message_Reply.sender_id.user_id)
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اهــلا عزيزي\n⤈︙ تم رفع العضو قرد واضافه إلى قائمه القروده")
elseif text== "تنزيل قرد"  and msg.reply_to_message_id then 
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الترفيه معطل من قبل المشرفين","md",true)
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
redis:srem(bot_id.."QERD"..msg.chat_id, Message_Reply.sender_id.user_id)
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اهــلا عزيزي\n⤈︙ تم تنزيل العضو من قائمه القروده")
elseif text== "رفع حمار"  and msg.reply_to_message_id then
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الترفيه معطل من قبل المشرفين","md",true)
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
redis:sadd(bot_id.."HEMAR"..msg.chat_id, Message_Reply.sender_id.user_id)
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اهــلا عزيزي\n⤈︙ تم رفع العضو حمار \n⤈︙ وتمت اضافته إلى قائمه الحمير")
elseif text== "تنزيل حمار"  and msg.reply_to_message_id then    
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الترفيه معطل من قبل المشرفين","md",true)
end
local list = redis:smembers(bot_id.."bot_idath"..msg.chat_id)
if #list == 0 then return bot.sendText(msg.chat_id,msg.id, "⤈︙ لا يوجد زقات") end
t = "\n⤈︙ قائمه الطليان\nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(list) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
username = '@'..UserInfo.username..''
else
username = v 
end
t = t..""..k.."~ : "..username.."\n"
if #list == k then
return bot.sendText(msg.chat_id,msg.id, t)
end
end
elseif text == ("البقر") then
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الترفيه معطل من قبل المشرفين","md",true)
end
local list = redis:smembers(bot_id.."klp"..msg.chat_id)
if #list == 0 then return bot.sendText(msg.chat_id,msg.id, "⤈︙ لا يوجد بقر") end
t = "\n⤈︙ قائمة البقر\nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(list) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
username = '@'..UserInfo.username..''
else
username = v 
end
t = t..""..k.."~ : "..username.."\n"
if #list == k then
return bot.sendText(msg.chat_id,msg.id, t)
end
end
elseif text == ("الجلاب") then
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الترفيه معطل من قبل المشرفين","md",true)
end
local list = redis:smembers(bot_id.."donke"..msg.chat_id)
if #list == 0 then return bot.sendText(msg.chat_id,msg.id, "⤈︙ لا يوجد كلاب") end
t = "\n⤈︙ قائمة الجلاب\nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(list) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
username = '@'..UserInfo.username..''
else
username = v 
end
t = t..""..k.."~ : "..username.."\n"
if #list == k then
return bot.sendText(msg.chat_id,msg.id, t)
end
end
elseif text == ("الاغبياء") then
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الترفيه معطل من قبل المشرفين","md",true)
end
local list = redis:smembers(bot_id.."zahf"..msg.chat_id)
if #list == 0 then return bot.sendText(msg.chat_id,msg.id, "⤈︙ لا يوجد اغبياء") end
t = "\n⤈︙ قائمة الاغبياء\nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(list) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
username = '@'..UserInfo.username..''
else
username = v 
end
t = t..""..k.."~ : "..username.."\n"
if #list == k then
return bot.sendText(msg.chat_id,msg.id, t)
end
end
elseif text == ("القروده") then
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الترفيه معطل من قبل المشرفين","md",true)
end
local list = redis:smembers(bot_id.."QERD"..msg.chat_id)
if #list == 0 then return bot.sendText(msg.chat_id,msg.id, "⤈︙ لا يوجد قروده") end
t = "\n⤈︙ قائمه القروده\nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(list) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
username = '@'..UserInfo.username..''
else
username = v 
end
t = t..""..k.."~ : "..username.."\n"
if #list == k then
return bot.sendText(msg.chat_id,msg.id, t)
end
end
elseif text == ("الحمير") then
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الترفيه معطل من قبل المشرفين","md",true)
end
local list = redis:smembers(bot_id.."HEMAR"..msg.chat_id)
if #list == 0 then return bot.sendText(msg.chat_id,msg.id, "⤈︙ لا يوجد حمير") end
t = "\n⤈︙ قائمه الحمير\nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in pairs(list) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
username = '@'..UserInfo.username..''
else
username = v 
end
t = t..""..k.."~ : "..username.."\n"
if #list == k then
return bot.sendText(msg.chat_id,msg.id, t)
end
end
end
if text and text:match('^ضع رتبه @(%S+) (.*)$') then
if not redis:get(bot_id.."redis:setRt"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ ضع رتبه معطلة من قبل المشرفين","md",true)
end
if text:match("مطور اساسي") or text:match("المطور الاساسي") or text:match("مطور الاساسي") or text:match("ثانوي") or text:match("مطور") then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ خطأ ، اختر رتبة اخرى ","md",true)
end
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص الادمن * ',"md",true)  
end
local UserName = {text:match('^ضع رتبه @(%S+) (.*)$')}
local UserId_Info = bot.searchPublicChat(UserName[1])
if not UserId_Info.id then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا يوجد حساب بهذا المعرف ","md",true)  
end
if UserId_Info.type.is_channel == true then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا تستطيع استخدام معرف قناة او كروب ","md",true)  
end
if UserName[1] and UserName[1]:match('(%S+)[Bb][Oo][Tt]') then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا تستطيع استخدام معرف البوت ","md",true)  
end
redis:set(bot_id..':SetRt'..msg.chat_id..':'..UserId_Info.id,UserName[2])
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ وضعتله رتبه : "..UserName[2],"md",true)  
end
if text and text:match('^ضع رتبه (.*)$') and msg.reply_to_message_id ~= 0 then
if not redis:get(bot_id.."redis:setRt"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ ضع رتبه معطلة من قبل المشرفين","md",true)
end
if text:match("مطور اساسي") or text:match("المطور الاساسي") or text:match("مطور الاساسي") or text:match("ثانوي") or text:match("مطور") then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ خطأ ، اختر رتبة اخرى ","md",true)
end
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص الادمن * ',"md",true)  
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
redis:set(bot_id..':SetRt'..msg.chat_id..':'..Message_Reply.sender_id.user_id,text:match('^ضع رتبه (.*)$'))
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ وضعتله رتبه : "..text:match('^ضع رتبه (.*)$'),"md",true)  
end
if text and text:match('^مسح رتبه @(%S+)$') then
if not redis:get(bot_id.."redis:setRt"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ ضع رتبه معطلة من قبل المشرفين","md",true)
end
if text:match("مطور اساسي") or text:match("المطور الاساسي") or text:match("مطور الاساسي") or text:match("ثانوي") or text:match("مطور") then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ خطأ ، اختر رتبة اخرى ","md",true)
end
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص الادمن * ',"md",true)  
end
local UserName = text:match('^مسح رتبه @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا يوجد حساب بهذا المعرف ","md",true)  
end
if UserId_Info.type.is_channel == true then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا تستطيع استخدام معرف قناة او كروب ","md",true)  
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا تستطيع استخدام معرف البوت ","md",true)  
end
redis:del(bot_id..':SetRt'..msg.chat_id..':'..UserId_Info.id)
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ مسحت رتبته","md",true)  
end
if text and text:match('^مسح رتبه$') and msg.reply_to_message_id ~= 0 then
if not redis:get(bot_id.."redis:setRt"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ ضع رتبه معطلة من قبل المشرفين","md",true)
end
if text:match("مطور اساسي") or text:match("المطور الاساسي") or text:match("مطور الاساسي") or text:match("ثانوي") or text:match("مطور") then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ خطأ ، اختر رتبة اخرى ","md",true)
end
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص الادمن * ',"md",true)  
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
redis:del(bot_id..':SetRt'..msg.chat_id..':'..Message_Reply.sender_id.user_id)
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ مسحت رتبته ","md",true)  
end

if text == "شبيهي" then
if not redis:get(bot_id.."shapeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ شبيهي معطل من قبل المشرفين","md",true)
end
Abs = math.random(2,140); 
local Text ='*الصراحه اتفق هذا شبيهك .*'
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = ' ‹ Source Time › ⁦ ', url = "https://t.me/YAYYYYYY"}
},
}
local msg_id = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. msg.chat_id .. '&photo=https://t.me/VVVVBV1V/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end

if text == "شبيهتي" then
if not redis:get(bot_id.."shapeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ شبيهتي معطل من قبل المشرفين","md",true)
end
Abs = math.random(2,140); 
local Text ='*الصراحه اتفق هذي شبيهتك .*'
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = ' ‹ Source Time › ⁦ ', url = "https://t.me/YAYYYYYY"}
},
}
local msg_id = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. msg.chat_id .. '&photo=https://t.me/VVVYVV4/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end

if text == "غنيلي" or text == "غني" then
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اوامر التسليه معطله بواسطه المشرفين .","md",true)
end
Abs = math.random(2,552);
local Text ='⤈︙ تم اختيار الاغنيه لك .'
local MsgId = msg.id/2097152/0.5
local MSGID = string.gsub(MsgId,'.0','')
keyboard = {}
keyboard.inline_keyboard = {{{text = '‹ NeXt ↻ ›', callback_data = msg.sender_id.user_id..'/rewrrt'}},
{{text = ' ‹ Source Time › ⁦ ', url = "https://t.me/YAYYYYYY"}}}
local msg_id = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. msg.chat_id .. '&voice=https://t.me/rewrrt/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..MsgId.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if text == "قران" or text == "قرأن" then
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اوامر التسليه معطله بواسطه المشرفين .","md",true)
end
Abs = math.random(2,552);
local Text ='⤈︙ تم اختيار القرأن لك .'
local MsgId = msg.id/2097152/0.5
local MSGID = string.gsub(MsgId,'.0','')
keyboard = {}
keyboard.inline_keyboard = {{{text = '‹ NeXt ↻ ›', callback_data = msg.sender_id.user_id..'/rrurrw'}},
{{text = ' ‹ Source Time › ⁦ ', url = "https://t.me/YAYYYYYY"}}}
local msg_id = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. msg.chat_id .. '&voice=https://t.me/rrurrw/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..MsgId.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if text == "راب" or text == "رابات" then
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اوامر التسليه معطله بواسطه المشرفين .","md",true)
end
Abs = math.random(2,552);
local Text ='⤈︙ تم اختيار الراب لك .'
local MsgId = msg.id/2097152/0.5
local MSGID = string.gsub(MsgId,'.0','')
keyboard = {}
keyboard.inline_keyboard = {{{text = '‹ NeXt ↻ ›', callback_data = msg.sender_id.user_id..'/redatw'}},
{{text = ' ‹ Source Time › ⁦ ', url = "https://t.me/YAYYYYYY"}}}
local msg_id = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. msg.chat_id .. '&voice=https://t.me/redatw/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..MsgId.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if text == "صوره" or text == "افتار" then
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اوامر التسليه معطله بواسطه المشرفين .","md",true)
end
Abs = math.random(2,140);
local Text ='⤈︙ تم اختيار الصوره لك .'
local MsgId = msg.id/2097152/0.5
local MSGID = string.gsub(MsgId,'.0','')
keyboard = {}  
keyboard.inline_keyboard = {{{text = '‹ صوره اخرى ›',callback_data = msg.sender_id.user_id..'/aftar'}}} 
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. msg.chat_id .. '&photo=https://t.me/nyx441/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..MsgId.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "ميمز" or text == "ميمزات" then
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اوامر التسليه معطله بواسطه المشرفين .","md",true)
end
Abs = math.random(2,552);
local Text ='⤈︙ تم اختيار الميمز لك .'
local MsgId = msg.id/2097152/0.5
local MSGID = string.gsub(MsgId,'.0','')
keyboard = {}
keyboard.inline_keyboard = {{{text = '‹ NeXt ↻ ›', callback_data = msg.sender_id.user_id..'/mmez4'}},
{{text = ' ‹ Source Time › ⁦ ', url = "https://t.me/YAYYYYYY"}}}
local msg_id = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. msg.chat_id .. '&voice=https://t.me/mmez4/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..MsgId.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if text == "صور شباب" or text == "افتار شباب" then
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اوامر التسليه معطله بواسطه المشرفين .","md",true)
end
Abs = math.random(2,140);
local Text ='⤈︙ تم اختيار الصوره لك .'
local MsgId = msg.id/2097152/0.5
local MSGID = string.gsub(MsgId,'.0','')
keyboard = {}  
keyboard.inline_keyboard = {{{text = '‹ صوره اخرى ›',callback_data = msg.sender_id.user_id..'/aftboy'}}} 
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. msg.chat_id .. '&photo=https://t.me/avboytol/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..MsgId.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "صور بنات" or text == "افتار بنات" then
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اوامر التسليه معطله بواسطه المشرفين .","md",true)
end
Abs = math.random(2,140);
local Text ='⤈︙ تم اختيار الصوره لك .'
local MsgId = msg.id/2097152/0.5
local MSGID = string.gsub(MsgId,'.0','')
keyboard = {}  
keyboard.inline_keyboard = {{{text = '‹ صوره اخرى ›',callback_data = msg.sender_id.user_id..'/aftgir'}}} 
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. msg.chat_id .. '&photo=https://t.me/QXXX_4/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..MsgId.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "قيف" or text == "متحركه" or text == "متحركة" then
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اوامر التسليه معطله بواسطه المشرفين .","md",true)
end
Abs = math.random(2,140);
local Text ='⤈︙ تم اختيار المتحركه لك .'
local MsgId = msg.id/2097152/0.5
local MSGID = string.gsub(MsgId,'.0','')
keyboard = {}  
keyboard.inline_keyboard = {{{text = '‹ متحركه اخرى ›',callback_data = msg.sender_id.user_id..'/gifed'}}} 
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendanimation?chat_id=' .. msg.chat_id .. '&animation=https://t.me/qwqwgif/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..MsgId.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "فلم" or text == "افلام" then
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اوامر التسليه معطله بواسطه المشرفين .","md",true)
end
Abs = math.random(2,140);
local Text ='⤈︙ تم اختيار الفلم لك .'
local MsgId = msg.id/2097152/0.5
local MSGID = string.gsub(MsgId,'.0','')
keyboard = {}  
keyboard.inline_keyboard = {{{text = '‹ فلم اخر ›',callback_data = msg.sender_id.user_id..'/fillm'}}} 
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. msg.chat_id .. '&photo=https://t.me/RRRRRTQ/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..MsgId.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "انمي" or text == "انميي" then
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اوامر التسليه معطله بواسطه المشرفين .","md",true)
end
Abs = math.random(2,140);
local Text ='⤈︙ تم اختيار الانمي لك .'
local MsgId = msg.id/2097152/0.5
local MSGID = string.gsub(MsgId,'.0','')
keyboard = {}  
keyboard.inline_keyboard = {{{text = '‹ انمي اخر ›',callback_data = msg.sender_id.user_id..'/anme'}}} 
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. msg.chat_id .. '&photo=https://t.me/anmee344/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..MsgId.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "ستوري" or text == "استوري" then
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اوامر التسليه معطله بواسطه المشرفين .","md",true)
end
Abs = math.random(2,140);
local Text ='⤈︙ تم اختيار الاستوري لك .'
local MsgId = msg.id/2097152/0.5
local MSGID = string.gsub(MsgId,'.0','')
keyboard = {}  
keyboard.inline_keyboard = {{{text = '‹ ستوري اخر ›',callback_data = msg.sender_id.user_id..'/stor'}}} 
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendanimation?chat_id=' .. msg.chat_id .. '&animation=https://t.me/stortolen/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..MsgId.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "ريمكس" or text == "ريماكس" then
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اوامر التسليه معطله بواسطه المشرفين .","md",true)
end
Abs = math.random(2,552);
local Text ='⤈︙ تم اختيار الريمكس لك .'
local MsgId = msg.id/2097152/0.5
local MSGID = string.gsub(MsgId,'.0','')
keyboard = {}
keyboard.inline_keyboard = {{{text = '‹ NeXt ↻ ›', callback_data = msg.sender_id.user_id..'/remix'}},
{{text = ' ‹ Source Time › ⁦ ', url = "https://t.me/YAYYYYYY"}}}
local msg_id = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. msg.chat_id .. '&voice=https://t.me/remix/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..MsgId.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end



if text == "شعر" or text == "اشعار" then
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ اوامر التسليه معطله بواسطه المشرفين .","md",true)
end
Abs = math.random(2,552);
local Text ='⤈︙ تم اختيار الشعر لك .'
local MsgId = msg.id/2097152/0.5
local MSGID = string.gsub(MsgId,'.0','')
keyboard = {}
keyboard.inline_keyboard = {{{text = '‹ NeXt ↻ ›', callback_data = msg.sender_id.user_id..'/sherru2'}},
{{text = ' ‹ Source Time › ⁦ ', url = "https://t.me/YAYYYYYY"}}}
local msg_id = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. msg.chat_id .. '&voice=https://t.me/sherru2/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..MsgId.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end

if text == "هلو" or text == "هلاو" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"هـلابـيك قـلبـي نـورت💘","هـلاوات يحات مـسيوو وايد💘😻","هـلابـيك/ج يـحـيلـي🥺","هـلاوات عمࢪيي مـسيو كـلش كـلش🥺💘"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "شلونكم" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"تـمـام عمࢪيي نتا ڪيفڪ💘💋","تـمام ونت گـيفـك قـلبـي💘"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "شلونك" or text == "شلونج" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"عمࢪࢪيي قـميـل بخيࢪ اذا حـلو بخيࢪ💘🙊","بـخيـر يـحيـلي ونـت💘","الحمدلله انت/ي شـخبارك/ج☹️"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "تمام" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"تـدوم عمࢪيي💘","دومـك/ج قـلبـي💘","دومـك/ج ياربي☹️","يـدوم احـبابـك/ج🥺"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "😐" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"شـبي حـلـو صـافـن😻💋","لـيش حـلـو صـافـن😹🥺"," لاتـصـفـن عـمـࢪيي😹"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "هاي" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"هـايـات يلصاڪ نـوࢪتـنـا💘","هـايـا يـحـلو انـرت🥺✨"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "اريد اكبل" or text == "اريد ارتبط" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"امـشي وخࢪ مـنـا يدوࢪ تـڪـبيل😏","وخـࢪ مـنـا مـاࢪيـد زواحـف😹","ادعـبل ابـنـي😚","اࢪتـبـط مـحـد لازمـك🙊","خـل اࢪتـبـط انـي بالاول😹"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "ريد ازحف" or text == "ازحفلج" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"شـعليڪ بـي عمࢪيي خـلي يـزحف💘☹️","عـيـب ابـنـي😐😹","شـگـبـࢪگ شـعـرضـك تـزحـف😹😕","بـعـدگ زغـيـࢪ ع زحـف ابـنـي😹😒"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "كلخرا" or text == "اكليخرا" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"اسـف عمࢪيي مـا خليڪ بـحـلڪي😹??","خـلـي ࢪوحـك مـاعـون 😹😘","اوگ اكــلـتـك/ج😹😹"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "دي" or text == "دد" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"امـشـيڪ بـيها عمࢪيي"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "فروخ" or text == "فرخ" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"ويـنـه بـلـه خـل حـصـࢪه😹🤤","ويـنـه بـلـه خـل تـفـل عـلـيه💦😗"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "تعي خاص" or text == "خ" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"هااا يـول اخـذتـها خـاص😹🙊","گـفـو اخـذتـهـا خـاص😉😹","بـخـت ࢪاحـو خـاص😭"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "اكرهج" or text == "اكرهك" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"عـساس انـي مـيـت بيڪڪ دمـشـي لڪ😿😹"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "احبك" or text == "احبج" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"يـحـياتـي وانـي هـم حـبـڪڪ🙈💋"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "باي" or text == "بايي" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"ويـن رايـح عمࢪيي خـلـينـا مـونـسـيـن🥺💘","لله وياگ ضـلـعي😗","سـد بـاب وࢪاگ😹"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "عوائل" or text == "صايره عوائل" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"عمࢪيي الـحلـو انـي ويـاڪ نـسـولف🥺😻","حـبيـبي ولله ࢪبـط فـيـشه ويـانـا🙈💋"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "واكف" or text == "بوت واكف" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"شـغال عمࢪيي🤓💘"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "ون مدير" or text == "وين مدير" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"عمࢪيي تـفـضل وياڪ مـديـࢪ💘"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "نجب" or text == "انجب" or text == "انجبي" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"صـاࢪ عمࢪيي💘🥺","لش عـمࢪيي شـسويت☹️💔"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "تحبيني" or text == "تحبني" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"سـؤال صـعـب خلـيـني افڪࢪ☹️"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "صباحو" or text == "صباح الخير" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"يـمـه فـديـت صباحڪ 💋🙈","صـباح قـشطه واللوز للحـلو💋🙊"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "كفو" or text == "كفوو" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"ڪـفـو مـنڪ عمࢪيي💘"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "شسمج" or text == "شسمك" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"اسـمـي احـلاهـن واتـحداهـن😹😹💘","اسـمـي صڪاࢪ بـنـات😗💘"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "مساء الخير" or text == "مسائو" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"مـساء العـافـيه عمࢪيي🥺","مسـآء الـياسـمين💋💘"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "رايح للمدرسه" or text == "مدرسه" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"لاجـيـب اسـمـها لاسـطࢪڪ😏😹"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "هههه" or text == "ههههه" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"فـدوا عـساا دوم💘","ضڪه تࢪد ࢪوح دايـمه عمغࢪيي🙈💘"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "احبجج" or text == "حبج" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"جـذاب تࢪا يـضـحڪ علـيـج😼💘"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end

if text == 'السيرفر' then
if not devB(msg.sender_id.user_id) then 
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المطور الاساسي * ',"md",true)  
end
bot.sendText(msg.chat_id,msg.id, io.popen([[
linux_version=`lsb_release -ds`
memUsedPrc=`free -m | awk 'NR==2{printf "%sMB/%sMB {%.2f%}\n", $3,$2,$3*100/$2 }'`
HardDisk=`df -lh | awk '{if ($6 == "/") { print $3"/"$2" ~ {"$5"}" }}'`
CPUPer=`top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'`
uptime=`uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"days,",h+0,"hours,",m+0,"minutes."}'`
echo '⤈︙  ⤈︙⊱ { نظام التشغيل } ⊰⤈︙\n*»» '"$linux_version"'*' 
echo '*⤈︙-----------------------------\n*⤈︙  ⤈︙⊱ { الذاكره العشوائيه } ⊰⤈︙\n*»» '"$memUsedPrc"'*'
echo '*⤈︙-----------------------------\n*⤈︙  ⤈︙⊱ { وحـده الـتـخـزيـن } ⊰⤈︙\n*»» '"$HardDisk"'*'
echo '*⤈︙-----------------------------\n*⤈︙  ⤈︙⊱ { الـمــعــالــج } ⊰⤈︙\n*»» '"`grep -c processor /proc/cpuinfo`""Core ~ {$CPUPer%} "'*'
echo '*⤈︙-----------------------------\n*⤈︙  ⤈︙⊱ { الــدخــول } ⊰⤈︙\n*»» '`whoami`'*'
echo '*⤈︙-----------------------------\n*⤈︙  ⤈︙⊱ { مـده تـشغيـل الـسـيـرفـر } ⊰⤈︙  \n*»» '"$uptime"'*'
]]):read('*all'),"md")
end

if text and text:match('^صلاحياته @(%S+)$') then
local UserName = text:match('^صلاحياته @(%S+)$') 
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا يوجد حساب بهذا المعرف ","md",true)  
end
if UserId_Info.type.is_channel == true then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا تستطيع استخدام معرف قناة او كروب ","md",true)  
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا تستطيع استخدام معرف البوت ","md",true)  
end
local StatusMember = bot.getChatMember(msg.chat_id,UserId_Info.id).status.luatele
if (StatusMember == "chatMemberStatusCreator") then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ الصلاحيات : مالك الكروب","md",true) 
elseif (StatusMember == "chatMemberStatusAdministrator") then
StatusMemberChat = 'مشرف الكروب'
else
return bot.sendText(msg.chat_id,msg.id,"⤈︙ الصلاحيات : عضو في الكروب" ,"md",true) 
end
if StatusMember == "chatMemberStatusAdministrator" then 
local GetMemberStatus = bot.getChatMember(msg.chat_id,UserId_Info.id).status
if GetMemberStatus.can_change_info then
change_info = '✅️️' else change_info = '❌️'
end
if GetMemberStatus.can_delete_messages then
delete_messages = '✅️️' else delete_messages = '❌️'
end
if GetMemberStatus.can_invite_users then
invite_users = '✅️️' else invite_users = '❌️'
end
if GetMemberStatus.can_pin_messages then
pin_messages = '✅️️' else pin_messages = '❌️'
end
if GetMemberStatus.can_restrict_members then
restrict_members = '✅️️' else restrict_members = '❌️'
end
if GetMemberStatus.can_promote_members then
promote = '✅️️' else promote = '❌️'
end
local PermissionsUserr = '*\n⤈︙ صلاحياته :\nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉'..'\n⤈︙ تغيير المعلومات : '..change_info..'\n⤈︙ تثبيت الرسائل : '..pin_messages..'\n⤈︙ اضافه مستخدمين : '..invite_users..'\n⤈︙ مسح الرسائل : '..delete_messages..'\n⤈︙ حظر المستخدمين : '..restrict_members..'\n⤈︙ اضافه المشرفين : '..promote..'\n\n*'
return bot.sendText(msg.chat_id,msg.id,"⤈︙ الصلاحيات : مشرف الكروب"..(PermissionsUserr or '') ,"md",true) 
end
end
if text == 'نزلني' then
if not redis:get(bot_id.."Abs:Nzlne:Abs"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ امر نزلني معطل من قبل المشرفين","md",true)
end
if Controllerbanall(msg.sender_id.user_id,msg.chat_id) == true then 
return bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذراً لا استطيع تنزيل { "..Get_Rank(msg.sender_id.user_id,msg.chat_id).." } *","md",true)  
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = ' نعم ', data = msg.sender_id.user_id..'/Nzlne'},{text = ' لا ', data = msg.sender_id.user_id..'/noNzlne'},
},
{
{text = ' ‹ Source Time › ⁦ ', url = 't.me/YAYYYYYY'}, 
},
}
}
return bot.sendText(msg.chat_id,msg.id,' ⤈︙ هل انت متأكد ؟',"md",false, false, false, false, reply_markup)
end

if text and text:match('^التفاعل @(%S+)$') then
local UserName = text:match('^التفاعل @(%S+)$') 
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا يوجد حساب بهذا المعرف ","md",true)  
end
if UserId_Info.type.is_channel == true then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا تستطيع استخدام معرف قناة او كروب ","md",true)  
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا تستطيع استخدام معرف البوت ","md",true)  
end
TotalMsg = redis:get(bot_id..":"..msg.chat_id..":"..UserId_Info.id..":message") or 1
TotalMsgT = Total_message(TotalMsg) 
return bot.sendText(msg.chat_id,msg.id,"⤈︙ "..TotalMsgT, "md")
end
if text and text:match('^الرتبه @(%S+)$') then
local UserName = text:match('^الرتبه @(%S+)$') 
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا يوجد حساب بهذا المعرف ","md",true)  
end
if UserId_Info.type.is_channel == true then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا تستطيع استخدام معرف قناة او كروب ","md",true)  
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا تستطيع استخدام معرف البوت ","md",true)  
end
local RinkBot = Get_Rank(msg.chat_id,UserId_Info.id)
return bot.sendText(msg.chat_id,msg.id,RinkBot, "md")
end
if text and text:match("^كول (.*)$") then
if redis:get(bot_id.."Abs:kol:Abs"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id, text:match('كول (.*)'),"md",true)  
end
end
if text and text:match("^كولي (.*)$") then
if redis:get(bot_id.."Abs:kol:Abs"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id, text:match('كولي (.*)'),"md",true)  
end
end
if text == 'id' or text == 'Id' or text == 'ID' then
local ban = bot.getUser(msg.sender_id.user_id)
if ban.first_name then
news = " "..ban.first_name.." "
else
news = " لا يوجد"
end
if ban.first_name then
UserName = ' '..ban.first_name..' '
else
UserName = 'لا يوجد'
end
if ban.username then
banusername = '@'..ban.username..''
else
banusername = 'لا يوجد'
end
local UserId = msg.sender_id.user_id
local RinkBot = Get_Rank(msg.sender_id.user_id,msg.chat_id)
local TotalMsg = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":message") or 1
local news = 'ɪᴅ : '..UserId
local uass = 'ɴᴀᴍᴇ : '..UserName
local banhas = 'ᴜѕᴇ : '..banusername
local rengk = 'ѕᴛᴀ : '..RinkBot
local masha = 'ᴍѕɢ : '..TotalMsg
local BIO = 'ʙɪᴏ : '..GetBio(msg.sender_id.user_id)
local again = '[ ‹ Source Time › ⁦ ](t.me/YAYYYYYY)'
local reply_markup = bot.replyMarkup{type = 'inline',data = {
{
{text = uass, url = "https://t.me/"..ban.username..""}, 
},
{
{text = news, url = "https://t.me/"..ban.username..""}, 
},
{
{text = banhas, url = "https://t.me/"..ban.username..""}, 
},
{
{text = rengk, url = "https://t.me/"..ban.username..""}, 
},
{
{text = masha, url = "https://t.me/"..ban.username..""}, 
},
{
{text = BIO, url = "https://t.me/"..ban.username..""}, 
},
}
}
return bot.sendText(msg.chat_id, msg.id, again, 'md', false, false, false, false, reply_markup)
end

if text == 'ثنائي' then
if not redis:get(bot_id.."thnaee"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الثنائي معطل من قبل المشرفين","md",true)
end
time = os.date("*t")
hour = time.hour
min = time.min
sec = time.sec
local_time = hour..":"..min
local Info_Members = bot.searchChatMembers(msg.chat_id, "*", 40)
local List = Info_Members.members
local Zozne = List[math.random(#List)] 
local data = bot.getUser(Zozne.member_id.user_id)
tagname = data.first_name
tagname = tagname:gsub("]","") 
tagname = tagname:gsub("[[]","") 
local Zozn = List[math.random(#List)] 
local dataa = bot.getUser(Zozn.member_id.user_id)
tagnamee = dataa.first_name
tagnamee = tagnamee:gsub("]","") 
tagnamee = tagnamee:gsub("[[]","") 
Text = "["..tagname.."](tg://user?id="..Zozne.member_id.user_id..")"
Textt = "["..tagnamee.."](tg://user?id="..Zozn.member_id.user_id..")"
local Textx = ""..Text.." + "..Textt.." = ❤"
bot.sendText(msg.chat_id,msg.id,Textx,"md",true)  
end
if msg.content.text then
if string.find(text,'tiktok') then
local get = io.popen('curl -s "https://black-source.xyz/Api/tk.php?u='..URL.escape(text)..'"'):read('*a')
local json = JSON.decode(get)
if json['url'][1]['url'] then
https.request("https://api.telegram.org/bot"..Token..'/sendvideo?chat_id=' .. msg.chat_id .. '&video='..json['url'][1]['url']..'&caption=' .. URL.escape(json['meta']['title'].."\n"..json['meta']['duration']).."&reply_to_message_id="..(msg.id/2097152/0.5).."&parse_mode=markdown&disable_web_page_preview=true")
end
end
end
if text == 'لقبي' then
local StatusMember = bot.getChatMember(msg.chat_id,msg.sender_id.user_id)
if StatusMember.status.custom_title ~= "" then
Lakb = StatusMember.status.custom_title
else
Lakb = 'مشرف'
end
if (StatusMember.status.luatele == "chatMemberStatusCreator") then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ لقبك ( '..Lakb..' )* ',"md",true)  
elseif (StatusMember.status.luatele == "chatMemberStatusAdministrator") then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ لقبك ( '..Lakb..' )* ',"md",true)  
else
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ انت عضو في الكروب* ',"md",true)  
end
end

if text == 'كشف البوت' or text == 'صلاحيات البوت' then 
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص الادمن * ',"md",true)  
end
local StatusMember = bot.getChatMember(msg.chat_id,bot_id).status.luatele
if (StatusMember ~= "chatMemberStatusAdministrator") then
return bot.sendText(msg.chat_id,msg.id,'⤈︙ البوت عضو في الكروب ',"md",true) 
end
local GetMemberStatus = bot.getChatMember(msg.chat_id,bot_id).status
if GetMemberStatus.can_change_info then
change_info = '✅️️' else change_info = '❌️'
end
if GetMemberStatus.can_delete_messages then
delete_messages = '✅️️' else delete_messages = '❌️'
end
if GetMemberStatus.can_invite_users then
invite_users = '✅️️' else invite_users = '❌️'
end
if GetMemberStatus.can_pin_messages then
pin_messages = '✅️️' else pin_messages = '❌️'
end
if GetMemberStatus.can_restrict_members then
restrict_members = '✅️️' else restrict_members = '❌️'
end
if GetMemberStatus.can_promote_members then
promote = '✅️️' else promote = '❌️'
end
PermissionsUser = '*\n⤈︙ صلاحيات البوت في الكروب :\nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉'..'\n⤈︙ تغيير المعلومات : '..change_info..'\n⤈︙ تثبيت الرسائل : '..pin_messages..'\n⤈︙ اضافه مستخدمين : '..invite_users..'\n⤈︙ مسح الرسائل : '..delete_messages..'\n⤈︙ حظر المستخدمين : '..restrict_members..'\n⤈︙ اضافه المشرفين : '..promote..'\n\n*'
return bot.sendText(msg.chat_id,msg.id,PermissionsUser,"md",true) 
end

if text == 'كشف المجموعه' or text == 'كشف المجموعة' or text == 'كشف الكروب' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص الادمن* ',"md",true)  
end
local Info_Members = bot.getSupergroupMembers(msg.chat_id, "Administrators", "*", 0, 200)
local List_Members = Info_Members.members
for k, v in pairs(List_Members) do
if Info_Members.members[k].status.luatele == "chatMemberStatusCreator" then
local UserInfo = bot.getUser(v.member_id.user_id)
if UserInfo.first_name ~= "" then
if UserInfo.username then
Creatorr = "*⤈︙ مالك الكروب : @"..UserInfo.username.."*\n"
else
Creatorr = "⤈︙ مالك الكروب : *["..UserInfo.first_name.."](tg://user?id="..UserInfo.id..")\n"
end
bot.sendText(msg.chat_id,msg.id,Creatorr,"md",true)  
end
end
end
local Info_Members = redis:smembers(bot_id..":"..msg.chat_id..":Status:Creator") 
if #Info_Members ~= 0 then
local ListMembers = '\n*⤈︙ قائمه المالكين \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*\n'
for k, v in pairs(Info_Members) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id, msg.id, ListMembers, 'md')
end
local Info_Members = redis:smembers(bot_id..":"..msg.chat_id..":Status:BasicConstructor") 
if #Info_Members ~= 0 then
local ListMembers = '\n*⤈︙ قائمه المنشئين الاساسيين \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*\n'
for k, v in pairs(Info_Members) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id, msg.id, ListMembers, 'md')
end
local Info_Members = redis:smembers(bot_id..":"..msg.chat_id..":Status:Constructor") 
if #Info_Members ~= 0 then
local ListMembers = '\n*⤈︙ قائمه المنشئين  \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*\n'
for k, v in pairs(Info_Members) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id, msg.id, ListMembers, 'md')
end
local Info_Members = redis:smembers(bot_id..":"..msg.chat_id..":Status:Owner") 
if #Info_Members ~= 0 then
local ListMembers = '\n*⤈︙ قائمه المدراء  \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*\n'
for k, v in pairs(Info_Members) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id, msg.id, ListMembers, 'md')
end
local Info_Members = redis:smembers(bot_id..":"..msg.chat_id..":Status:Administrator") 
if #Info_Members ~= 0 then
local ListMembers = '\n*⤈︙ قائمه الادمنيه  \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*\n'
for k, v in pairs(Info_Members) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id, msg.id, ListMembers, 'md')
end
local Info_Members = redis:smembers(bot_id..":"..msg.chat_id..":Status:Vips") 
if #Info_Members ~= 0 then
local ListMembers = '\n*⤈︙ قائمه المميزين  \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*\n'
for k, v in pairs(Info_Members) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id, msg.id, ListMembers, 'md')
end
end
if text == 'تاك للكل' and Administrator(msg) then
if not redis:get(bot_id.."taggg"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ التاك للكل معطل بواسطه المشرفين .","md",true)
end
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
local Info = bot.searchChatMembers(msg.chat_id, "*", 200)
local members = Info.members
ls = '\n*⤈︙ قائمه الاعضاء \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ *\n'
for k, v in pairs(members) do
local UserInfo = bot.getUser(v.member_id.user_id)
if UserInfo.username and UserInfo.username ~= "" then
ls = ls..'*'..k..' - *@['..UserInfo.username..']\n'
else
if UserInfo.first_name and UserInfo.first_name ~= "" then
tagname = UserInfo.first_name
tagname = tagname:gsub('"',"")
tagname = tagname:gsub('"',"")
tagname = tagname:gsub("`","")
tagname = tagname:gsub("*","") 
tagname = tagname:gsub("_","")
tagname = tagname:gsub("]","")
tagname = tagname:gsub("[[]","")
ls = ls..'*'..k..' - *['..tagname..'](tg://user?id='..v.member_id.user_id..')\n'
else
ls = ls..'*'..k..' ⤈︙ *[محذوف](tg://user?id='..v.member_id.user_id..')\n'
end
end
end
bot.sendText(msg.chat_id,msg.id,ls,"md",true)  
end
--------------------------------------------------------------------------------
if text and text:match('^اهداء @(%S+)$') then
local UserName = text:match('^اهداء @(%S+)$') 
mmsg = bot.getMessage(msg.chat_id,msg.reply_to_message_id)
if mmsg and mmsg.content then
if mmsg.content.luatele ~= "messageVoiceNote" and mmsg.content.luatele ~= "messageAudio" then
return bot.sendText(msg.chat_id,msg.id,'*⤈︙ عذرأ لا ادعم هذا النوع من الاهدائات*',"md",true)  
end
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
return bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ لا يوجد حساب بهذا المعرف*","md",true)   end
local UserInfo = bot.getUser(UserId_Info.id)
if UserInfo.first_name and UserInfo.first_name ~= "" then
local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '‹ رابط الاهداء ›', url ="https://t.me/c/"..string.gsub(msg.chat_id,"-100",'').."/"..(msg.reply_to_message_id/2097152/0.5)}}}}
local UserInfom = bot.getUser(msg.sender_id.user_id)
if UserInfom.username and UserInfom.username ~= "" then
Us = '@['..UserInfom.username..']' 
else 
Us = 'لا يوجد ' 
end
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
return bot.sendText(msg.chat_id,msg.reply_to_message_id,'*⤈︙ هذا الاهداء لـك ( @'..UserInfo.username..' ) عمري فقط ♥️\n⤈︙ اضغط على رابط الهداء للستماع الى البصمة  ↓\n⤈︙ صاحب الاهداء هـوه »* '..Us..'',"md",true, false, false, false, reply_markup)  
end
end
end
if text == 'تاك للمتفاعلين' or text == 'منشن للمتفاعلين' or text == 'المتفاعلين' then
if not redis:get(bot_id.."taggg"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ التاك معطل بواسطه المشرفين .","md",true)
end
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط . * ',"md",true)  
end
local Info_Members = bot.searchChatMembers(msg.chat_id, "*", 25)
local List_Members = Info_Members.members
listall = '\n*⤈︙ قائمه المتفاعلين في المجموعه \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ *\n'
for k, v in pairs(List_Members) do
local UserInfo = bot.getUser(v.member_id.user_id)
if UserInfo.username ~= "" then
listall = listall.."*"..k.." - @"..UserInfo.username.."*\n"
else
listall = listall.."*"..k.." -* ["..UserInfo.id.."](tg://user?id="..UserInfo.id..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,listall,"md",true)  
end

if text == "تحدي" then
local Info_Members = bot.searchChatMembers(msg.chat_id, "*", 200)
local List = Info_Members.members
local Zozne = List[math.random(#List)] 
local data = bot.getUser(Zozne.member_id.user_id)
tagname = data.first_name
tagname = tagname:gsub("]","") 
tagname = tagname:gsub("[[]","") 
local Textinggt = {"تعترف له/ا بشي", "تقول له أو لها اسم امك", "تقول له او لها وين ساكن", "تقول كم عمرك", "تقول اسم ابوك", "تقول عمرك له", "تقول له كم مرا حبيت", "تقول له اسم سيارتك", "تقولين له اسم امك", "تقولين له انا احبك", "تقول له انت حيوان", "تقول اسمك الحقيقي له", "ترسله اخر صور", "تصور له وين جالس", "تعرف لها بشي", "ترسله كل فلوسك بالبوت", "تصور لها غرفتك", "تصور/ين عيونك وترسلها بالكروب", "ترسل سنابك او ترسلين سنابك", }
local Descriptioont = Textinggt[math.random(#Textinggt)]
Text = "اتحداك\n"..Descriptioont.." ↤ ["..tagname.."](tg://user?id="..Zozne.member_id.user_id..")"
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end 

if text == "ترند الكروبات" or text == "ترند المجموعات" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ Source Time ›',url="https://t.me/YAYYYYYY"}}
}
}
if not redis:get(bot_id.."GroupUserCountMsg:groups"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ ترند الكروبات معطل بواسطه المشرفين .","md",true)
end
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط . * ',"md",true)  
end
GroupAllRtba = redis:hgetall(bot_id..':GroupUserCountMsg:groups')
GetAllNames  = redis:hgetall(bot_id..':GroupNameUser:groups')
GroupAllRtbaL = {}
for k,v in pairs(GroupAllRtba) do table.insert(GroupAllRtbaL,{v,k}) end
Count,Kount,i = 8 , 0 , 1
for _ in pairs(GroupAllRtbaL) do Kount = Kount + 1 end
table.sort(GroupAllRtbaL, function(a, b) return tonumber(a[1]) > tonumber(b[1]) end)
if Count >= Kount then Count = Kount end
Text = "*⤈︙ قائمه ترند الكروبات 📊. \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*\n"
for k,v in pairs(GroupAllRtbaL) do
if v[2] and v[2]:match("(-100%d+)") then
local InfoChat = bot.getChat(v[2])
local InfoChats = bot.getSupergroupFullInfo(v[2])
if InfoChats.code ~= 400 then
if not InfoChats.invite_link then
linkedid = "["..InfoChat.title.."]" or "خطأ بالأسـم"
else
linkedid = "["..InfoChat.title.."]("..InfoChats.invite_link.invite_link..")"
end
if i <= Count then  
Text = Text..i.." -  "..(linkedid).." ↫  ‹ *"..v[1].."* ›  \n" 
end ; 
i=i+1
end
end
end
return bot.sendText (msg.chat_id,msg.id,Text,"md",true, false, false, false, reply_markup)
end
if text and msg.chat_id then
local GetMsg = redis:incr(bot_id..'bot_id:MsgNumbergroups'..msg.chat_id) or 1
redis:hset(bot_id..':GroupUserCountMsg:groups',msg.chat_id,GetMsg)
end
if text == "روابط الكروبات" or text == "جلب الروابط" then
if not devB(msg.sender_id.user_id) then 
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ الامر يخص المطور الاساسي فقط .* ',"md",true)  
end
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
GroupAllRtba = redis:hgetall(bot_id..':GroupUserCountMsg:groups')
GetAllNames  = redis:hgetall(bot_id..':GroupNameUser:groups')
GroupAllRtbaL = {}
for k,v in pairs(GroupAllRtba) do table.insert(GroupAllRtbaL,{v,k}) end
Count,Kount,i = 8 , 0 , 1
for _ in pairs(GroupAllRtbaL) do Kount = Kount + 1 end
table.sort(GroupAllRtbaL, function(a, b) return tonumber(a[1]) > tonumber(b[1]) end)
if Count >= Kount then Count = Kount end
Text = "*⤈︙ قائمه روابط المجموعات في البوت . \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*\n"
for k,v in pairs(GroupAllRtbaL) do
if v[2] and v[2]:match("(-100%d+)") then
local InfoChat = bot.getChat(v[2])
local InfoChats = bot.getSupergroupFullInfo(v[2])
if InfoChats.code ~= 400 then
if not InfoChats.invite_link then
linkedid = "["..link.."]" or "خطأ بالأسـم"
else
linkedid = "["..link.."]("..InfoChats.invite_link.invite_link..")"
end
if i <= Count then  
Text = Text..i.." -  "..(linkedid).." \n" 
end ; 
i=i+1
end
end
end
return bot.sendText (msg.chat_id,msg.id,Text,"md",true, false, false, false, reply_markup)
end
if text and msg.chat_id then
local GetMsg = redis:incr(bot_id..'bot_id:MsgNumbergroups'..msg.chat_id) or 1
redis:hset(bot_id..':GroupUserCountMsg:groups',msg.chat_id,GetMsg)
end
if text == "بيست" or text == "ممكن بيست" then
local Info_Members = bot.searchChatMembers(msg.chat_id, "*", 200)
local List = Info_Members.members
local Zozne = List[math.random(#List)] 
local data = bot.getUser(Zozne.member_id.user_id)
tagname = data.first_name
tagname = tagname:gsub("]","") 
tagname = tagname:gsub("[[]","") 
local Textinggt = {" ‌‌‏حَـب عَظيمَ ݪبيستك ", 
"خِتاݛيتݪك هݪبسَيت ݛبي يديمَكمَ", 
"‌‏هذا بيسَتك يديمَكمَ ياݛب 🎀",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
Text = "\n*"..Descriptioont.." *: ["..tagname.."](tg://user?id="..Zozne.member_id.user_id..")"
local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '‹ اخفاء › ', data =msg.sender_id.user_id..'/'.. 'delAmr'},},}}
bot.sendText(msg.chat_id,msg.id,Text,"md",false ,false, false,false,reply_markup)
end
if text == "نداء" or text == "ناديهم" then
if not redis:get(bot_id.."..Zozne.member_id.user_id.."..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ النداء معطل بواسطه المشرفين .","md",true)
end
local Info_Members = bot.searchChatMembers(msg.chat_id, "*", 200)
local List = Info_Members.members
local Zozne = List[math.random(#List)] 
local data = bot.getUser(Zozne.member_id.user_id)
tagname = data.first_name
tagname = tagname:gsub("]","") 
tagname = tagname:gsub("[[]","") 
local Textinggt = {" ‌‏-‏حـب عظيم لڪل لحظه جمـيله بيني وبينڪ🌼", 
"حيلي على حيلك لو شفت التعب صابك ??", 
"مچانت امنيتي اذا مَر بيك اسمي تگول احبه🤍", 
"- أبتسّمي فلا جمِيلة إلا أنتِ 🤍", 
"- يا أخطرُ وجهٍ عربيَّيا أجِملُ نُِساء الأرُض 🤍", 
"- يـ المعدل يگلهن بيك يلمامش شِعر يكفيك 🤍", 
"ѕᴛᴏʀʏ‏جُرعه مِن حضنك تجعلني أقاوم هُراء العالم", 
"- أنتِ الشروق و أنتِ النور في عُمري 🤍", 
"عنـدما احـادثك ابــتسم حبـاً دون ان اشــعر", 
"انا بنت قويهۂ لكـטּ قلبـⴢ̤ قلب طفلهۂ ??💘🦋", 
"- مِثل الشيب عايش أبيض ومَذموم", 
"ﭑبتسميَ فـ لايليق بالقمرِ أن يحزن ♥️⚜️", 
"اروحَـن وين؟ آنه ولايـتـي عيونَك??✨??", 
"كيف لي ان ارى غيرك وانت عيناي🥺✨🖤", 
"-‏‏ - اقدس نفسيو كأني شيء كارثي⤈︙⤈︙♥️", 
"-‏‏ الجميع يظنّه صديقي وأنا أظنّه الجميع⤈︙♥️", 
" ؏ـَلـى ايـَدك اࢪيـد اخـتـَم عزوبيتـَي💍♥️", 
" سأختارك دائما وكأنك الوحيد والأبدي 💛", 
" لهُـم الحَـيآة بـہ اكملهـآ ولـي حضنڪ 💛", 
" شسويتلي وهالگد صرت مشتاگلك ♥️", 
"-‏‏حـضنڪـہ ثـم لـﭑ ﭑريـُد شـيء ﭑخـࢪ", 
"-‏‏ مَا تشتاكَلي ياا شمَالك نسِيت سوالفي الحّلوه ??💔", 
" شايف من تحب انسان وماتكدر تگله 🥺 💔💔", 
"-‏‏شما تنام يعيش بعيونك حلم كتاله باﭼر🥀", 
"-‏‏وانا حَاير بين انسّى وبين احِن💔", 
"-‏‏ انا متعـب يا الله الـم يحن وقت الرحـيل ????", 
" فشلتني گبال روحي وگابلت روحي وبچيت", 
" اشتقت لحديثك وكأني لم أحادثك منذ سنين", 
" الديرهَ المابيهه حسّك طافيّه بخدهه السٓوالف 🖤", 
" وعلي من گد ما أغار أتمنى كُل الناس أخوتچ ♥️", 
"مُجرد فتاة خابت كُل أمنيتهٌا🌻", 
" هي كانت تُشبه أغنيتي المُفضَّلة♡", 
" -نيتـي بيضه وبختـي يـم الله جبيـر🥺♥️", 
" و قد يغيّر الله كلَّ شيء بدعاءٍ صادق", 
" گلبك المابي محنةشينفع وياه العتب", 
" أنا النعمه التي ستبكيَ على فقدانهها 🤷🏻‍♀️):", 
"-‏‏ الأمر تخطى كونه حُبأنت جزء مني♡", 
" وأحببتك حب لٱ يعلمه الا م̷ـــِْن خلقك", 
"-‏‏مِن فرط رقـتۿا كَادت أن تَطيـر 🧕🏻🖤", 
"-‏‏ لأنھا قصيرة يصبح عناقھا أجمل 🙆🏻‍♀️💜", 
"-‏‏ وجـۿ متــعوب مـو ڪَـد مواليـدي 🙇🏿‍♀🖤", 
"-‏‏ لا رضـينه نـعيش جـذبه ولا تـونسنهبصدڪ 🙇??‍♀️??", 
" لا رضـينه نـعيش جـذبه ولا تـونسنهبصدڪ 🙇🏿‍♀️🖤", 
" امس غنيتلك حزني وغفيت انته 💔🙂", 
"-‏‏ اني يا يڪلموني ستالاف شخص بنفس الدقيقة يا محد يڪلمني :)", 
"-‏‏ ضيـعتني وأنـۿ رايـحمـني لاتتـناش جيـۿ",  
"-‏‏ أجَدَّك وطن وبِلاد وسّلام يعانقُني",  
"-‏‏ والشالج هذه معدل ماخذ غيره م̷ـــِْن العباس",  
"-‏‏ گلوب المايردها الشوگ شيردها",  
"ما الذي يشغل بالك في الفترة الحالية؟", 
"-‏‏ منـين ما التـفت الڪة العمـر ذبـلان", 
"-‏‏ اڪو نـاس مـثل الفحـم منیـن ماتـلزمهــم وصخیـن",  
" -شتفيد الاحبک وانتـه ماتعـرف تحبني؟",  
" -- ڪُل سـالفة تخصـڪتهـز ڪَلبي 🖤", 
"-‏‏ شڪَد ميـتريكس بسـوالف بعـض چنـة 🖤", 
" لا تفرح اذا حولك كثير ترا الرخص يجيب الزباين",  
" ‏كم هو مؤلم أن تترك سريرك كل صباح لترى أشكال تسد النفس 𖤐🌚💔",  
" ‏يڪللۿ تعآليلي هاي النآس ما تعرف تلوليّلي 𔘓", 
" ‏شلۅن عٓينك ناﭑمت ۅڪلبي يۅن 🙇‍♂💗🎻", 
" ‏- شَـوارع بغَـداد واغنُـية وعِيونڬ", 
" ‏- عـتڪَ خلڪَيوملامـح وجهـي ذبلانـة",  
" ‏- چـانت الدنـيا آمـان وچـانو أصحـابي بَـشر", 
"-‏‏ للخيانھ ألف بابً و ﺎحبابنا ما قصروا",  
"-‏‏ متبدل بطبعه الهوى لو حنا اتبدلنه",  
"-‏‏ السكوت وياك أحلى من الحچي وياهم 🤍", 
"-‏‏ ولو رأى الكافِرُعِيناك لـ قال أمنّا برب تِلك العُيون 🖤",
" ‏‏-‏ منذ أن عَرفتك حتى الآن كُنتُ على يقينٍ بأنني لن أُحب أحداً بهذا العمق والأنتماء",
"-‏‏ عيناكِ سحر كـاد يهلِكني , فمَن ذَا الذي عن جمالِ عيناكِ يصبِر",
" ‏‏-‏ هل خلق الجمال لتختصره عيناك عيونك أجمل من السماء بنجومها✨",
" ‏‏-‏ كل نواحي قلبي مغرمة فيك",
" ‏‏-‏‏يا ليّتني كل النَاظرين إليك",
" ‏‏-‏‏أحبُ الطريق إن كان نحوك",
" ‏‏-‏‏أحتى لو انتهى اللي بينا بتضل من اسعد الذكريات اللي عشتها بحياتي واتمنى انگ تكون بخير دايم",
" ‏‏-‏‏أوﺧـليـڪ ؏ـلـى טּـضࢪت شـوڪ تتـﺣـسـࢪ وࢪاويـڪ لوﺟـوه شلـوטּ مـטּ تـثڪـل بـصـيطه ابو ڪـࢪش😒",
" ‏‏-‏‏أوسكوت عَميق يَكتِمُ أنفاسي ويحطم قلبي", 
" -‏‏أابيك كلك وحقي وعشاني والله بلاك بعاشق حيييل أناني",
"-‏‏ستـَزول المسافـۿ يومـاً ما وأحتضنك 📮🤍",
"-‏‏ في كل مره تكسر قلبي بها احاول ان لا اكرهك لا اريد خسارتك او ان نفترق ارجوك كُف عن هذه الأفعال",
"-‏‏ حضن ايدك امان الدنيا كلها",
"-‏‏ أحببتك كما تحبك تلك ألتي أنجبتك وأكثر",
" ‏‏كـيف لـكتـاخذ قـلبي و انـت بـكل هـذا الـبعد ❤",
"ربااه أني احبه حبآ كائنمآ لم أحب أحدآ مثلما أحببته 🥺♥",
" ﭑريَدك ﭑنتهَۿِ مِا ﭑريد ﭑلايَام تجيبَ ﭑلاحَسن منكِ",
"- أود معانقتك حتى تسقط يداي تعبآ🖤🥀",
"في حلمي انت لي 😍لكن في واقعي انت حلمي😔",
"وڪونك تحِبني صَدك چا دوَرتني ♥️",
"صُحبتك زرعت بقلبي جناين ورد",
"‏الوقوع في حب شخص حنون نجاة❤️",
"-‏‏ يا جمـالاً ليس له اربعيـن", 
"-‏‏آخ يا ذاك التعب بدو أسنين الندى بحضن الگصب",
"-‏‏انتَ يَ الچنك دُعآء بشفة امي", 
"-‏‏وأحچيلك شكد حچي وتجاوب بكلمه",
"-‏‏‏لديَّ الكثير من الأصدقاء في صديقٍ واحد",
"-‏‏‏شحلاة ألشيب البشعرك ضوه مطَشر يا أول وجه يصغر شما يكبر", 
"-‏‏‏الضرۅف تصفي الاصحاب واحد واحد لا تستعجلون 🤷",
"-‏‏‏اسندج بگلبي اذا جان الجتف مخلوع 💔",
"-‏‏‏كــن لطيفاً بــحديثـك فـبعضـهم يـعانـي مـن ألـم الحياة",
"-‏‏‏چن هآي أخر رساله وچن ودآع تآليها",
"-‏‏‏لغيرج ههالكلب لا رحَـب و لا سَـلم", 
"-‏‏‏اكو حچايات ما تنگآل الآ عيونك گبالي", 
"-‏‏‏ردتك شيبه تبقه براسي حد ماموت",
"-‏‏‏هـاي الـدنيه تـريـد واهـس وانـي مـيتلي خـلك",
"-‏‏ مـثل الـعافـيه كـون تـصير مـوش بـكل وجـه تـنكال",
"-‏‏ الـحلام تـموت والاصـدقاء يـرحلون والـحب كـذبه سـتبقۍ وحيداً أعدك",
"-‏‏ وتـبقۍ الحمدالله هـي الكلمه الوحيده المعبره عـن كـل حـال",
"-‏‏ شـجاك وكـمت مـا تـشتاك هـوا الـشوك شيكلفك؟",
"-‏‏ أورثلك جكارة ونگعد نسولف واكلك شگد تَعبتني",
"-‏‏ ألليل وألحيل وسهر عيني الثگيل كلهن ألتمن يخايب من وراك", 
"-‏‏ من رمش لرمش بعيوني تتمشة", 
"-‏‏ انت تهمل وغيرك يهتمياسيدي والقلب ميال",
"-‏‏ المن ترد ضل غادِ عايش مبتِعد",
"-‏‏ مآبين الگطن والغيم والنجمات لونج ماخذ الاول", 
"-‏‏ حاجيني بعيونك حجيهن يختلف", 
"-‏‏ عيونج غنوة السبعين وحجايات بغدادية", 
"-‏‏ يا حنه بجفوف السهر مُر على طين ولايتي", 
"-‏‏ ڪٌل الأشيّاء الحِلوه تِشبَهه عيّونه", 
"-‏‏ احنا ناس گلوبنا تعيش برسالة", 
"-‏‏ اكتبلها شعر ودكلي المن هايمن فدوه لغبائج هيج مو يمج",
"-‏‏ يـﭑفـࢪحتي مـن تـمـࢪني وتـڪلي ﭑحـبج",
"وش الي تفكر فيه الحين؟",
"-‏‏ يكفينىمنالدنياوجودكجانبي", 
"-‏‏ باچر الأيام تحله وگلبك جروحه يوردن",
"-‏‏ أحـنه چـي نعشگ حلآل معَـذبين", 
"-‏‏ عليش اشتاگ وأنت بلاعذر غايب", 
"-‏‏ اكول قبل ماافتح عيوني افز واقرة رسايلها", 
"-‏‏ گالو الحرمل يغثك طگطگتلك هيل", 
"-‏‏ ضوگ روحك حتى تعذرني من اغار",
"-‏‏ ‏ تگوله خلي أتعب وأتعب وعلى سوالف صوتك أرتاح",
"-‏‏ ‏ شوكت الگاج يمي وأبقه صافن بيج", 
"-‏‏ حيل اشتاگ ‏بس مَحتار انطي ليا وِجه شوگي", 
"مين اكثر يخون البنات/العيال؟",
"-‏‏ بعد للحيل ماضل حيل ‏حتى نعاتبك يا ليل",
"-‏‏ خفيفة سوالفك چنهن مُطر صيف",
"-‏‏ ياريت الشاغلاتك كلهن آنه",
"-‏‏ ‏ تعبي ضاع مثل شامه بخد عبد ♡",
"-‏‏ عيش بيه الدنيا ما تستاهلَك♡",
"-‏‏ ‏كُلما أردت إلقاء نظرة على أجمل أيامي وجدتك",
"-‏‏ ‏أول مشاوير العمر جانت عيونك",
"-‏‏ ‏شعور قوي تكون انت سند لنفسك",
"-‏‏ ‏أستسهلوك بكثر ما شفتك صعب", 
"-‏‏ ‏خليتني بلايه خلگ ما أحمل حجايه", 
"-‏‏ ‏سالفتي طويلة وياك يمتى ألگاك",
"-‏‏ ‏أنام بحضن صوتك وأصبح ؏ خيرك", 
"-‏‏ ‏بعدها ألدنيا تلجمني وأجي أشكيلك", 
"-‏‏ لا يرغبُ اݪـمݛء في اݪـحب بقدر رغبتِه في أن يَفهمهُ أحدهُم",
"-‏‏ ‏خفِف حمولة قلبك بالتخلّي فليست كل الأشياء تستحق الاهتمام",
"-‏‏ ‏ﭑنت هَواي ؏ـايفنـჂ̤ ليـشہ تضوج مـטּ تَسمع غيرڪ واحد يحبنـჂ̤",
"-‏‏ دفوُ صوتك من يمُر تخِدر مدينه بحالهآ",
"-‏‏ كُن مختلفاً فالعالم لايريد مَزيد من النسخ",
"-‏‏ أُغنية بأُغنية والبادي ألطف", 
"-‏‏ منذ مجيئك إلى عالمي الكئيب بدأت أزهر",
"-‏‏ إستمع لأغنيتك المُفضلة وشاهد فيلمك المُفضل وتجنب الكائنات البشرية المزعجة♡",
"-‏‏ ‏تكلي شلون صحتك أكلك مابقت صحه♡",
"-‏‏ أُراقبك بشكل لا يوحي بأنني مُهتم وهذا بلائي♡",
"-‏‏ ‏‏يصبح الإنسان خطيراً عندما يتعلم كيف يتحكم بمشاعره♡",
"-‏‏ ‏‏كانوُا أخف مِن البَقاءكُنّا أثقَل مِن اللِحاق بِهُم♡",
"-‏‏ ‏‏‏يتعافى الإنسَان برسائِل من يُحب ♡",
"-‏‏ ‏‏‏المواقف تعطيك الإجابات بكُل وضوح فَلا تتظاهر بِالعمى♡",
"-‏‏ ‌‏لا أستطيع رؤيه سيئاتك كل ما أراه هو النقاء ♡",
"-‏‏ ‌‏حاچيني اشتهيت إسمي إعله گد صوتك♡",
"-‏‏ راهن على الذي لا يرتكب أخطاءً إملائية إلا في محادثتك♡",
"-‏‏ هذا العالم لا يُعامل اللطّف باللطّف♡",
"-‏‏ ڪلوب النااس ﻢ تشبةه شڪلهااه ♡",
"-‏‏ يمر الوڪت والـ ذڪرا ندامةه ♡",
"-‏‏ كلما زاد الوعي زاد اليأس ♡",
"-‏‏ ‏‏‏‏تجاهل كل شيء يزعجك الأيام لا تعوض♡",
"-‏‏ مضـيت بمفـࢪدي لم أࢪى أيـآآ منكم بجـانبي♡",
"-‏‏ ‏‏‏‏حلم سكران شيذكرك بعد بيه♡",
"-‏‏ بشـر بي راحـَتي وتعبـي♡",
"-‏‏ الإهتمام عظيم قد يغلب الحب احيانآ♡",
"-‏‏ ‏التظاهر بالسعادة أسهل من شرح حزنك للآخرين♡",
"-‏‏ قد ننسئ الألملكن لا ننسئ من زرعه♡",
"-‏‏ من لا يؤدبه ضميره تؤدبه الحياة حين تدور♡",
"-‏‏لڪنه لا يُغادر عقلي بينما يضن انّه اصبح منسي♡",
"-‏‏من يحبك حقاً هو من يبقى بجانبك عندما لاتطاق♡",
"-‏‏ أنـا ايضًا أتقـن التجاهلهل تَود التـجربة♡",
"-‏‏ݪماذا تبڪين دخلت الاغنيةه في عينـي♡",
"-‏‏لا شأن لي بجمال روحك مادام لسانك مؤذيآ♡",
"-‏‏من الغباءاطالة الندم علئ شيئ انتهئ♡",
"-‏‏ليس غرورآأنما انا فعلآ لا اتعوض♡",
"-‏‏انا دائما على استعداد لأفقد جميع الاشياء♡",
"-‏‏أجمل مافي التقدم في العمر أنه يجعلك تستصغر اموراً كثيرة♡",
"-‏‏واجه مشاكلك لوحدك كي تجد نفسك اقوئ من كل مره♡",
"-‏‏الانسحاب من الفوضى راحة لا مثيل لها♡",
"-‏‏ﺎڪره ان يشارڪني احد بأشيائي الخاصةه واولهن انتَ♡",
"-‏‏ ياهو احَن مني ويحبج ؟♡",
"-‏‏ شتفيد الاحبک وانتـه ماتعـرف تحبني♡",
"-‏‏ ﭑنَـت لو تـحچي ﭑلـصدڪ چا ما خسـرتڪك♡",
"-‏‏ عقل الشخص مغري اكثر من شكله♡",
"-‏‏ كثريلي من الزعل إذا چان العتب شبگة♡",
"-‏‏ أني مطمئنه لاني أثق بالله 🤍♡",
"-‏‏ آريـد اصفـن بوجهـك صفنـه الميتـين🤍♡",
"-‏‏الليلَ باك اعمارنه بحجهْ سهر 🤍♡",
"-‏‏ يـ المعدل يگلهن بيك يلمامش شِعر يكفيك 🤍♡",
"-‏‏ ناسّيني وانَه ألچنت بگلوُبهم گاعد لو مَيت وُلا شفت مَلگاهم ألبارَد ☹️💞💞??♡",
"-‏‏ نحلملاكننا مستمرين بالعيش 🙂🍷♡",
"-‏‏ ‏أميزك لو صرت براس النوارس شيب♥️💍♡",
"-‏‏ ‏‏أحبك دائماً كالمره الأولى♡",
"-‏‏ ‏‏ﭑبتسميَ فـ لايليق بالقمرِ أن يحزن ♥️⚜️♡",
"-‏‏ ‏‏اروحَـن وين؟ آنه ولايـتـي عيونَك🥺✨🖤♡",
"-‏‏ ‏‏كيف لي ان ارى غيرك وانت عيناي🥺✨🖤♡",
"-‏‏ ‏الجميع يظنّه صديقي وأنا أظنّه الجميع⤈︙♥️♡",
"-‏‏ ‏شلـون اختار غيرك وانـت ماليني✨♥️♡",
"-‏‏ ‏‏من عرفتك وأنـا قلبـي بالمحبة لك يزيد✨♥️",
"-‏‏ عيـــَونـه تخبـــل يـداده 👌💍♥️",
"-‏‏ لهُـم الحَـيآة بـہ اكملهـآ ولـي حضنڪ 💛",
"-‏‏ سأختارك دائما وكأنك الوحيد والأبدي 💛💛",
"-‏‏ ‏‏شسويتلي وهالگد صرت مشتاگلك ♥️💛",
"-‏‏ ‏‏سـأكون دائـمآ مـوجـودة لك ولأجـلك✨♥️💛",
"-‏‏ ‏‏الله وصانه بثلث نعمات عنده التـين والزيتون وأنتي ♥️",
"-‏‏ ‏‏يا رب البسلك الأبيض ويشهد العالم بحبنا 💍💛",
"-‏‏ ‏‏بينما انت تتجاهلها غيرك يرآاها سُڪر محلى 🤤♥💛",
"-‏‏ ‏‏يا أول سند للروح من يلتم عليها الهّم♥️🧜🏻‍♀️",
"-‏‏ ‏‏شِفت وجهك دنيا فرحانة و رحل عنها الحزن 🥺❤️",
"-‏‏ ‏‏محـلـيـَه ايامـي ومحليتنـي 🌻",
"-‏‏ ينتـۿي عمري ومينتهـي حبـَها",
"-‏‏ ‏بعيداً عن كل ما ابعدك عنياشتقت لك🥺💕",
"-‏‏ ‏و اللـه و الوطــن 🇮🇶وعيون محبوبي❤️🤭",
"-‏‏ ‏الله يديم قربك الله يملي كل ايامي فيك 💕",
"-‏‏ ‏‏انّغلبت عند عُيونِك انهزمْت هزيمَة حُب",
"-‏‏ ‏‏حَبيت حُضنَك واني محاضنتَك تخيل؟♥️🕊",
"-‏‏ ‏‏الحب مثل الحرب يرادله زلم ❤️🧚‍♂️",
"-‏‏ ‏‏‏﮼قلبييالمغرمهـوآك ﮼خلنيابقىٰمعآك❤️",
"-‏‏ ‏‏‏ڪَــلبي وياك مو عندي🥺💞❤️",
"-‏‏ في طريقي الف شخصوفي عيني انت وحدك ❤️",
"-‏‏ سأختارك دائما وكأنك الوحيد والأبدي 💛💛",
"-‏‏ ‏‏‏: ﺂنَت؏َـالمي ﺂلمصنوَ؏ مَن البهجه 🤍",
"-‏‏ ‏‏‏ٱنتَ فكرتي الأولى عندما أستيقظ ♥️🔐",
"-‏‏ ‏‏‏دحبني و خل انام الليلّ مثل الناس ♥️🔐",
"-‏‏ ‏‏‏توة راد يسولف البرحي بحلاتك وانسحن گلبة وسكت 💙",
"-‏‏ ‏‏‏أول الاحباب انتِ واخر الاحباب صوتك 🖤",
"-‏‏ ‏‏‏لقد ملكتَني أكثر ممّا أظُن وأكثر ممّا تظُن♥️",
"-‏‏ ‏‏‏مثل تُحفه تُراثيه شما يُمر الزمن تِغلى هالبنيه ♥️",
"-‏‏ ‏‏‏اكسـرلج زلم فوك الزلم نسوان اذا واحد تدنالج 😊♥️",
"-‏‏ ‏‏‏‏بكل أغنيه حلوه اغمض عيوني وأتخيلك♥️",
"-‏‏ ‏‏‏‏مو تحبهم شعجب ما حسو بهمك ☹️🖤♥️",
"-‏‏ ‏‏‏‏ ‏لقد كنت معزولاً ووحيدًا في كل مكان مُبهجـة حتى ظِلها ڪانَ مُلونـاً",
"-‏‏ ‏‏‏‏ ‏من ظَلمة عيونك والشَمس رُمحين جَلجَل ليلهن واتحَزمن بالشر 😌♥️",
"-‏‏ ‏‏‏‏ ‏چـم زلـة منك بَينت وما جيت آعاتب ♥️",
"-‏‏ ‏‏‏‏ ‏العّشتهن وحَدي مَحد حاس بيهّن 🖤ْ",
"-‏‏ ‏‏‏‏ ‏منين أجيب گليب يتحمل حِزن 🥺منين أجيب عيون ماتعرف تحنّ 💔",
"-‏‏ ‏‏‏‏ ‏انا الملاكـ وهن بقايا الريشَ المتساقط من اجنحتي 😌❤️",
"-‏‏ ‏‏‏‏ ‏خلص صبري وجمالك حيل شدني ومثل خيط الوبر خداه شدني يگلي ادني لحد شفتاي شدني شدني من الذنوب طنون بيه",
"-‏‏ ‏‏‏‏ ‏حلوه الدنيا لو كل القلوب انضاف ولاكن خربته الوادم الوصخه",
"-‏‏ ‏‏‏‏ ‏العدهه هيج اعيون خضره و وسيعةانطيهاحتى الروح والبيت ابيعه",
"-‏‏ ‏‏‏‏ ‏وين القه ثوب أيوب وشلون احصله بلكت صبر بي ضال واخذلي وصله",
"-‏‏ انتِي بس وافقي وانا والله لعيشك ملكه 😍",
"-‏‏ موكد جمر بالروح هجرك جواني حد ما طلع عطابكلبي امنذاني",
"-‏‏ ياطير المحنه هم سمعت بطير ماهزه الحنين لديرته وعشه",
"-‏‏ راجع بـ طرگ المواجع حيل أطگ راسي بشبابيچك ندّم",
"-‏‏ حسبـالي مثلي تحــن لو بينــت تعبـي غيمه وطردها الهوى هيج انطرد ڪلبي",
"-‏‏ نرجع ونگول مُطرموسيقىٰ وحضنك يداده",
"-‏‏ گودني لـ گلبَك واخِذنيالناس ما بيهُم وطَن",
"-‏‏ تهزمني ؏ـيونكہَ كل مَا نويت اقسَى 🎋",
"-‏‏ عانِقڼي٘ بـَ ﭑغنيةهَ لعَلڼا نلتِقي٘ علىَ ﭑطِݛافۿا",
"-‏‏ كيف احتضنك حتى لا تنام حزينًا ولا وحيدًا ولا خائفًا وبيننا مسافة الأرض",
"-‏‏ كيف ما احبك واسعد أوقاتي معاك 🤎؟*",
"-‏‏ قنوعه بكُلشي إلا بيكّ أكبر انانيه♥️🥺",
"-‏‏ حـب عظيم لڪل لحظه جمـيله بيني وبينڪ🌼",
"-‏‏ أنت القصة التي لا أريد أن تكون لها نهاية 💞💍",
"-‏‏ ولا شي يشبهك انت اجمل ماشافت عيوني🤍",
"-‏‏ ٱحبـڪَ لِـحَد ما يعجز ڪَلامَـي", 
"-‏‏ يا حِݪوتهن ڪُل حلوه بصفچ مو حݪوه 🤍📮",
"-‏‏ احبك نيابة ؏ـّن ڪل عناق فائت وعن ڪل مسافة منعت يداي من ملامسة وجهكَ",
"-‏‏ غير عيونَك آني شعندي",
"-‏‏ رَد بارد حضنّا وما حضناك",
"-‏‏ يا حبيبة قلبي انتي يابعد ناسي وهلي",
"-‏‏ وحدك اريدك تملي دنيايه وين اكو بگدي يحبك هوايه",
"-‏‏ يا عمي عدها خدود والكعبة تنعض والشفة مو ستريكس لا بيها الف حظ",
"-‏‏ انتَ عَينيونضر عَيني♡",
"-‏‏ ترفهَ والخَجل نايم عَلى أطراف الجّفن كُحِلة 🤎",
"-‏‏ فدوة لـ حچيك شگد ينحب ‏الهوا يدخل بريتك يطلع مرتب 📮🤍",
"-‏‏ ‏أرغبُ بأحتضانك لمده لاتقل عن ليلة كامله",
"-‏‏ ‏خَصر امرايةَ خُصرچ يَجرح الشوف",
"-‏‏ ‏متت لمَن شفت عينچ شَحچيلك ع عِيونها",
"-‏‏ ‏يالجنج كمَر نص ليل يطر الغيم ويضوي",
"-‏‏ ‏وكان الجمال لم يعرف طريقاً الا لكِ🖤",
"-‏‏ ‏دڪــافي نسولف مــن بعيد اريد اشكيلك مشابگ",
"-‏‏ ‏وينك يا دفـو يا جمر الاحزان احس بـدمي بـ الشريان جامد",
"-‏‏ ‏الدفء لا يقتَصر على ضوء الشمسحُضنكَ خيارٌ آخر💞💞💞💞💞💞",
"-‏‏ ‏شحچي عنك ‏كـلشي بالدنيا حلو مخلوق منّك♥️",
"-‏‏ ‏اكلك الحنيّة يلي بعيونك شلون تنباس♥️",
"-‏‏ ‏سنكون معاً ذات ليلة ممطرة",
"-‏‏ ‏انتَ والأغاني بڪُل وڪت مَرغوبين 🤍",
"-‏‏ گد ما بوجهك ضوى شكيت بيك وگلت بالشمس متلثم", }
local Descriptioont = Textinggt[math.random(#Textinggt)]
Text = "\n"..Descriptioont.." : ["..tagname.."](tg://user?id="..Zozne.member_id.user_id..")"
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end 
if text == 'تفعيل التاك التلقائي' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."bot_id:Tagat"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل التاك التلقائي بنجاح . *").by,"md",true)
end
if msg and redis:get(bot_id.."bot_id:Tagat"..msg.chat_id) then
if not redis:get(bot_id..":"..msg.chat_id..":tag") then
local Info = bot.searchChatMembers(msg.chat_id, "*", 200)
local members = Info.members
local InfoUser = bot.getUser(members[math.random(#members)].member_id.user_id)
local texting = {"⤈︙ تعال لك وين طامس :","⤈︙ الطف مخلوق حياتي 💖 :","⤈︙ الـهَيـبة 💖 :","⤈︙ يـا قمـري ❤️‍🔥 :","⤈︙ مس يحلو 🌚🤍 :","⤈︙ تعا مجمعين ناقصه بس انت يروحي 😔💖 :","⤈︙ وين طامس يحلو 🌚❤️‍🔥 :","⤈︙ تعا نورنه 😉🤍 :","⤈︙ احبك يحلو 😂👽 :","⤈︙ حنسوي العاب تعا 🌚💗 :","⤈︙ هاا طمست 😉🤍 :",}
tagname = InfoUser.first_name.."ْ"
tagname = tagname:gsub('"',"")
tagname = tagname:gsub('"',"")
tagname = tagname:gsub("`","")
tagname = tagname:gsub("*","") 
tagname = tagname:gsub("_","")
tagname = tagname:gsub("]","")
tagname = tagname:gsub("[[]","")
usr = "["..tagname.."](tg://user?id="..InfoUser.id..")"
redis:setex(bot_id..":"..msg.chat_id..":tag",30,true)
bot.sendText(msg.chat_id,0,'*'..texting[math.random(#texting)]..'*'..usr,'md') 
end
end
if text == 'تعطيل التاك التلقائي' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."bot_id:Tagat"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل التاك التلقائي بنجاح . *").by,"md",true)
end
if text == "زوجني" or text == "زوجيني" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
if not redis:get(bot_id.."zogne"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ زوجيني معطل من قبل المشرفين","md",true)
end
local Info_Members = bot.searchChatMembers(msg.chat_id, "*", 200)
local List = Info_Members.members
local Zozne = List[math.random(#List)] 
local data = bot.getUser(Zozne.member_id.user_id)
tagname = data.first_name
tagname = tagname:gsub("]","") 
tagname = tagname:gsub("[[]","") 
Text = "زوجتك ↓↓↓ \n["..tagname.."](tg://user?id="..Zozne.member_id.user_id..")"
bot.sendText(msg.chat_id,msg.id,Text,"md",true, false, false, false, reply_markup)
end 

if text == "اني منو" or text == 'منو اني' then
if not redis:get(bot_id.."anamen"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ انا مين معطل من قبل المشرفين","md",true)
end
if msg.sender_id.user_id == tonumber(1497373149) then
bot.sendText(msg.chat_id,msg.id,"⤈︙ انته العشق المبرمج مالتي 🍃♥️","md",true)
elseif msg.sender_id.user_id == tonumber(1497373149) then
bot.sendText(msg.chat_id,msg.id,"⤈︙ المبرمج عبود 🥺♥️","md",true)
elseif devB(msg.sender_id.user_id) then
bot.sendText(msg.chat_id,msg.id,"⤈︙ انت المطور الاساسي يقلبي🌚♥","md",true)
elseif programmer(msg) then
bot.sendText(msg.chat_id,msg.id,"⤈︙ اطلق مطور ثانوي 🤩","md",true)
elseif developer(msg) then
bot.sendText(msg.chat_id,msg.id,"⤈︙ احلى مطور 💚","md",true)
elseif Creator(msg) then
bot.sendText(msg.chat_id,msg.id,"⤈︙ انتا مالك الكروب ياقلبي 🥺","md",true)
elseif BasicConstructor(msg) then
bot.sendText(msg.chat_id,msg.id,"⤈︙ انتا منشئ اساسي حلو 🥰","md",true)
elseif Constructor(msg) then
bot.sendText(msg.chat_id,msg.id,"⤈︙ انتا منشئ 😊","md",true)
elseif Owner(msg) then
bot.sendText(msg.chat_id,msg.id,"⤈︙ انتا مدير كبير 💗","md",true)
elseif Administrator(msg) then
bot.sendText(msg.chat_id,msg.id,"⤈︙ انتا ادمن 🙂","md",true)
elseif Vips(msg) then
bot.sendText(msg.chat_id,msg.id,"⤈︙ احلى مميز اشوفه ❤","md",true)
else 
bot.sendText(msg.chat_id,msg.id,"⤈︙ انتا عضو بس 🥺🥺","md",true)
end 
end
if text == 'تفعيل اوامر النسب' or text == 'تفعيل النسب' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."nsab"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل اوامر النسب بنجاح . *").by,"md",true)
end

if text == 'تعطيل اوامر النسب' or text == 'تعطيل النسب' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."nsab"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل اوامر النسب بنجاح . *").by,"md",true)
end
-------------------------------- اوامر اخلاق

if text == 'تفعيل اوامر الاخلاق' or text == 'تفعيل الاخلاق' or text == 'تفعيل اخلاقي' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."aqlaq"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل اوامر الاخلاق *").by,"md",true)
end

if text == 'تعطيل اوامر الخلاق' or text == 'تعطيل الاخلاق' or text == 'تعطيل اخلاقي' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."aqlaq"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل اوامر الاخلاق *").by,"md",true)
end
----------------------- الاخلاق



------- جمالي 

if text == 'تفعيل اوامر جمالي' or text == 'تفعيل جمالي' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."jmal"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل اوامر جمالي *").by,"md",true)
end

if text == 'تعطيل اوامر جمالي' or text == 'تعطيل جمالي' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."jmal"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل اوامر جمالي *").by,"md",true)
end

---------------------------------------- جمالي ؟ نسبه جمالي
if text == 'تفعيل تتزوجيني' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."ttzog"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل تتزوجيني *").by,"md",true)
end

if text == 'تعطيل تتزوجيني' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."ttzog"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل تتزوجيني *").by,"md",true)
end

if text == 'تفعيل زوجني' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."zogne"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل زوجني *").by,"md",true)
end

if text == 'تعطيل زوجني' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."zogne"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل زوجني *").by,"md",true)
end
if text == 'تفعيل الالعاب' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."Status:Games"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل الالعاب بنجاح . *").by,"md",true)
end
if text == 'تعطيل الالعاب' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."Status:Games"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل الالعاب بنجاح . *").by,"md",true)
end
if text == 'تفعيل الردود العامه' then
if not devB(msg.sender_id.user_id) then 
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ الامر يخص المطور الاساسي فقط .* ',"md",true)  
end
redis:set(bot_id.."Zepra:Set:Rd"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل الردود العامه بنجاح . *").by,"md",true)
end
if text == 'تعطيل الردود العامه' then
if not devB(msg.sender_id.user_id) then 
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ الامر يخص المطور الاساسي فقط .* ',"md",true)  
end
redis:del(bot_id.."Zepra:Set:Rd"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل الردود العامه بنجاح . *").by,"md",true)
end
if text == 'تفعيل صورتي' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."aftare"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل صورتي بنجاح . *").by,"md",true)
end
if text == 'تعطيل صورتي' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."aftare"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل صورتي بنجاح . *").by,"md",true)
end
if text == 'تفعيل اوامر التسليه' or text == 'تفعيل التسليه' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."trfeh"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل اوامر التسليه بنجاح .*").by,"md",true)
end
if text == 'تعطيل اوامر التسليه' or text == 'تعطيل التسليه' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."trfeh"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل اوامر التسليه بنجاح .*").by,"md",true)
end
if text == 'تفعيل النداء' or text == 'تفعيل نداء' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."..Zozne.member_id.user_id.."..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل النداء بنجاح .*").by,"md",true)
end
if text == 'تعطيل النداء' or text == 'تعطيل نداء' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."..Zozne.member_id.user_id.."..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل النداء بنجاح .*").by,"md",true)
end
if text == 'تفعيل اضف نقاط' or text == 'تفعيل النقاط' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id..":game"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل اضف نقاط بنجاح .*").by,"md",true)
end
if text == 'تعطيل اضف نقاط' or text == 'تعطيل النقاط' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id..":game"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل اضف نقاط بنجاح .*").by,"md",true)
end
if text == 'تفعيل اضف رسائل' or text == 'تفعيل الرسائل' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id..":settings:game:"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل اضف رسائل بنجاح .*").by,"md",true)
end
if text == 'تعطيل اضف رسائل' or text == 'تعطيل الرسائل' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id..":settings:game:"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل اضف رسائل بنجاح .*").by,"md",true)
end
if text == 'تفعيل انا مين' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."anamen"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل مين انا *").by,"md",true)
end
if text == 'تعطيل انا مين' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."anamen"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل مين انا *").by,"md",true)
end
if text == 'تفعيل شبيهي' or TextMsg == 'تفعيل شبيهتي' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."shapeh"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل شبيهي *").by,"md",true)
end
if text == 'تعطيل شبيهي' or TextMsg == 'تعطيل شبيهتي' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."shapeh"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل شبيهي *").by,"md",true)
end
if text == 'تفعيل الانذارات' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."indar"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل الانذارات *").by,"md",true)
end
if text == 'تعطيل الانذارات' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."indar"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل الانذارات *").by,"md",true)
end
if text == 'تفعيل الثنائي' or TextMsg == 'تفعيل الثنائي' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."thnaee"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل الثنائي بنجاح . *").by,"md",true)
end
if text == 'تعطيل الثنائي' or TextMsg == 'تعطيل الثنائي' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."thnaee"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل الثنائي بنجاح . *").by,"md",true)
end
if text == 'تفعيل ضع رتبه' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."redis:setRt"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل ضع رتبه *").by,"md",true)
end
if text == 'تعطيل ضع رتبه' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."redis:setRt"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل ضع رتبه *").by,"md",true)
end
if text == 'تفعيل التاك للكل' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."taggg"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل التاك للكل بنجاح . *").by,"md",true)
end
if text == 'تعطيل التاك للكل' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."taggg"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل التاك للكل بنجاح . *").by,"md",true)
end
if text == 'تفعيل التاك للمتفاعلين' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."taggg"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل التاك للمتفاعلين بنجاح . *").by,"md",true)
end
if text == 'تعطيل التاك للمتفاعلين' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."taggg"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل التاك للمتفاعلين بنجاح . *").by,"md",true)
end
if text == 'تفعيل نزلني' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."Abs:Nzlne:Abs"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل نزلني *").by,"md",true)
end
if text == 'تعطيل نزلني' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."Abs:Nzlne:Abs"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل نزلني *").by,"md",true)
end
if text == 'تفعيل منو ضافني' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."Abs:Addme:Abs"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل منو ضافني بنجاح .*").by,"md",true)
end
if text == 'تعطيل منو ضافني' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."Abs:Addme:Abs"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل منو ضافني بنجاح .*").by,"md",true)
end
if text == 'تفعيل كول' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."Abs:kol:Abs"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل كول بنجاح .*").by,"md",true)
end
if text == 'تعطيل كول' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."Abs:kol:Abs"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل كول بنجاح .*").by,"md",true)
end
if text == 'تفعيل الترند' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."userTypeRegular"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل الترند بنجاح . *").by,"md",true)
end
if text == 'تعطيل الترند' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."userTypeRegular"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل الترند بنجاح . *").by,"md",true)
end
if text == 'تفعيل ترند الكروبات' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."GroupUserCountMsg:groups"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل ترند الكروبات بنجاح . *").by,"md",true)
end
if text == 'تعطيل ترند الكروبات' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."GroupUserCountMsg:groups"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل ترند الكروبات بنجاح . *").by,"md",true)
end
if text == 'تفعيل الزخرفه' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."myzhrfa"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل الزخرفه بنجاح . *").by,"md",true)
end
if text == 'تعطيل الزخرفه' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."myzhrfa"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل الزخرفه بنجاح . *").by,"md",true)
end
if text == 'تفعيل الابراج' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."brjj"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل الابراج بنجاح . *").by,"md",true)
end
if text == 'تعطيل الابراج' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."brjj"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل الابراج بنجاح . *").by,"md",true)
end
if text == 'تفعيل حساب العمر' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."calculate"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل حساب العمر بنجاح . *").by,"md",true)
end
if text == 'تعطيل حساب العمر' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."calculate"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل حساب العمر بنجاح . *").by,"md",true)
end
if text == 'تفعيل انطقي' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."&caption=الكلمة"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل انطقي بنجاح . *").by,"md",true)
end
if text == 'تعطيل انطقي' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."&caption=الكلمة"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل انطقي بنجاح . *").by,"md",true)
end
if text == 'تفعيل التحقق' or text == 'تفعيل تحقق' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id.."Status:joinet"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل التحقق بنجاح . *").by,"md",true)
end
if text == 'تعطيل التحقق' or text == 'تعطيل تحقق' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id.."Status:joinet"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل التحقق بنجاح . *").by,"md",true)
end
if text == 'تفعيل الاقتباسات' or text == 'تفعيل اقتباسات' or text == 'تفعيل وضع الاقتباسات' or text == 'تفعيل وضع اقتباسات' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:del(bot_id..'Status:Reply'..msg.chat_id)
redis:set(bot_id.."Status:aktbas"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل الاقتباسات بنجاح . بنجاح . *").by,"md",true)
end
if text == 'تعطيل الاقتباسات' or text == 'تعطيل اقتباسات' or text == 'تعطيل وضع الاقتباسات' or text == 'تعطيل وضع اقتباسات' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
redis:set(bot_id..'Status:Reply'..msg.chat_id,true)
redis:del(bot_id.."Status:aktbas"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل الاقتباسات بنجاح . *").by,"md",true)
end

if text == 'تفعيل امسح' and Creator(msg) then      
if redis:get(bot_id..":"..msg.chat_id..":Amsh") then
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":Amsh")  
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل امسح' and Creator(msg) then     
if not redis:get(bot_id..":"..msg.chat_id..":Amsh") then
redis:set(bot_id..":"..msg.chat_id..":Amsh",true)  
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end

if text then
if text:match('^انذار @(%S+)$') then
if not redis:get(bot_id.."indar"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ الانذارات مقفلة من قبل المشرفين","md",true)
end
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص الادمن* ',"md",true)  
end
local UserName = text:match('^انذار @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا يوجد حساب بهاذا المعرف ","md",true)  
end
if UserId_Info.type.is_channel == true then
return bot_id(msg.chat_id,msg.id,"\n⤈︙ عذراً لا تستطيع استخدام معرف قناة او كروب ","md",true)  
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا تستطيع استخدام معرف البوت ","md",true)  
end
local UserInfo = bot.getUser(UserId_Info.id)
local zz = redis:get(bot_id.."zz"..msg.chat_id..UserInfo.id)
if not zz then
redis:set(bot_id.."zz"..msg.chat_id..UserInfo.id,"1")
return bot.sendText(msg.chat_id,msg.id,Reply_Status(UserInfo.id,"⤈︙  تم عطيته انذار ").heloo,"md",true)  
end
if zz == "1" then
redis:set(bot_id.."zz"..msg.chat_id..UserInfo.id,"2")
return bot.sendText(msg.chat_id,msg.id,Reply_Status(UserInfo.id,"⤈︙  تم عطيته انذار وصار عنده انذارين ").heloo,"md",true)  
end
if zz == "2" then
redis:del(bot_id.."zz"..msg.chat_id..UserInfo.id)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'كتمه', data = msg.sender_id.user_id..'mute'..UserInfo.id}, 
},
{
{text = 'تقييده', data = msg.sender_id.user_id..'kid'..UserInfo.id},  
},
{
{text = 'حظره', data = msg.sender_id.user_id..'ban'..UserInfo.id}, 
},
}
}
return bot.sendText(msg.chat_id,msg.id,Reply_Status(UserInfo.id,"⤈︙  تم عطيته انذار وصاروا ثلاثة ").heloo,"md",true, false, false, true, reply_markup)
end
end 
end
if text == ('انذار') and msg.reply_to_message_id ~= 0 then
if not redis:get(bot_id.."indar"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الانذارات مقفلة من قبل المشرفين","md",true)
end
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص الادمن* ',"md",true)  
end
if msg.can_be_deleted_for_all_users == false then
return bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذراً البوت ليس ادمن في الكروب يرجى رفعه وتفعيل الصلاحيات له *","md",true)  
end
if GetInfoBot(msg).Delmsg == false then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ البوت ليس لديه صلاحيه مسح الرسائل* ',"md",true)  
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Message_Reply.sender_id.user_id)
if UserInfo.message == "Invalid user ID" then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً تستطيع فقط استخدام الامر على المستخدمين ","md",true)  
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا تستطيع استخدام الامر على البوت ","md",true)  
end
if not Norank(Message_Reply.sender_id.user_id,msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذراً لا تستطيع استخدام الامر على ( "..Get_Rank(Message_Reply.sender_id.user_id,msg.chat_id).." ) *","md",true)  
end
local zz = redis:get(bot_id.."zz"..msg.chat_id..Message_Reply.sender_id.user_id)
if not zz then
redis:set(bot_id.."zz"..msg.chat_id..Message_Reply.sender_id.user_id,"1")
return bot.sendText(msg.chat_id,msg.id,Reply_Status(Message_Reply.sender_id.user_id,"⤈︙  تم عطيته انذار ").heloo,"md",true)  
end
if zz == "1" then
redis:set(bot_id.."zz"..msg.chat_id..Message_Reply.sender_id.user_id,"2")
return bot.sendText(msg.chat_id,msg.id,Reply_Status(Message_Reply.sender_id.user_id,"⤈︙  تم عطيته انذار وصار عنده انذارين ").heloo,"md",true)  
end
if zz == "2" then
redis:del(bot_id.."zz"..msg.chat_id..Message_Reply.sender_id.user_id)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'كتمه', data = msg.sender_id.user_id..'mute'..Message_Reply.sender_id.user_id}, 
},
{
{text = 'تقييده', data = msg.sender_id.user_id..'kid'..Message_Reply.sender_id.user_id},  
},
{
{text = 'حظره', data = msg.sender_id.user_id..'ban'..Message_Reply.sender_id.user_id}, 
},
}
}
return bot.sendText(msg.chat_id,msg.id,Reply_Status(Message_Reply.sender_id.user_id,"⤈︙  تم عطيته انذار وصاروا ثلاثة ").heloo,"md",true, false, false, true, reply_markup)
end
end
if text == ('مسح الانذارات') or text == ('مسح انذاراته') or text == ('مسح انذارات') and msg.reply_to_message_id ~= 0 then
if not redis:get(bot_id.."indar"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الانذارات مقفلة من قبل المشرفين","md",true)
end
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص الادمن* ',"md",true)  
end
if msg.can_be_deleted_for_all_users == false then
return bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذراً البوت ليس ادمن في الكروب يرجى رفعه وتفعيل الصلاحيات له *","md",true)  
end
if GetInfoBot(msg).BanUser == false then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ البوت ليس لديه صلاحيه حظر المستخدمين* ',"md",true)  
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Message_Reply.sender_id.user_id)
if UserInfo.message == "Invalid user ID" then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً تستطيع فقط استخدام الامر على المستخدمين ","md",true)  
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا تستطيع استخدام الامر على البوت ","md",true)  
end
redis:del(bot_id.."zz"..msg.chat_id..Message_Reply.sender_id.user_id)
return bot.sendText(msg.chat_id,msg.id,Reply_Status(Message_Reply.sender_id.user_id,"⤈︙  تم مسحت كل انذاراته").heloo,"md",true)  
end

if text == ('ابلاغ') or text == ('تبليغ') and msg.reply_to_message_id ~= 0 then
	if msg.can_be_deleted_for_all_users == false then
		return bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذراً البوت ليس ادمن في الكروب يرجى رفعه وتفعيل الصلاحيات له *","md",true)  
	end
	if GetInfoBot(msg).Delmsg == false then
		return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ البوت ليس لديه صلاحيه مسح الرسائل* ',"md",true)  
	end
	local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
	local UserInfo = bot.getUser(Message_Reply.sender_id.user_id)
	if UserInfo.message == "Invalid user ID" then
		return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً تستطيع فقط استخدام الامر على المستخدمين ","md",true)  
	end
	if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
		return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا تستطيع استخدام الامر على البوت ","md",true)  
	end
if not Norank(Message_Reply.sender_id.user_id,msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذراً لا تستطيع استخدام الامر على { "..Get_Rank(Message_Reply.sender_id.user_id,msg.chat_id).." } *","md",true)  
end
	local Info_Members = bot.getSupergroupMembers(msg.chat_id, "Administrators", "*", 0, 200)
	local List_Members = Info_Members.members
	for k, v in pairs(List_Members) do
		if Info_Members.members[k].status.luatele == "chatMemberStatusCreator" then
			local UserInfo = bot.getUser(v.member_id.user_id)
			if UserInfo.first_name == "" then
				bot.sendText(msg.chat_id,msg.id,"*⤈︙ المالك حسابه محذوف ⤈︙*","md",true)  
				return false
			end
			local photo = bot.getUserProfilePhotos(v.member_id.user_id)
			if UserInfo.username then
				Creatorrr = "*⤈︙ مالك الكروب ~⪼ @"..UserInfo.username.."*\n"
			else
				Creatorrr = "*⤈︙ مالك الكروب ~⪼ *["..UserInfo.first_name.."](tg://user?id="..UserInfo.id..")\n"
			end
			if UserInfo.first_name then
				Creat = ""..UserInfo.first_name.."\n"
			else
				Creat = "⤈︙ مالك الكروب \n"
			
			end
		end
	end
	bot.sendText(msg.chat_id,msg.id,Reply_Status(Message_Reply.sender_id.user_id,"⤈︙ تم الابلاغ على رسالته\nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"..Creatorrr.."").heloo,"md",true)
end
if text == ('رفع مشرف') and msg.reply_to_message_id ~= 0 then
if not programmer(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المنشئ* ',"md",true)  
end
if msg.can_be_deleted_for_all_users == false then
return bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذراً البوت ليس ادمن في المجموعه يرجى رفعه وتفعيل الصلاحيات له *","md",true)  
end
if GetInfoBot(msg).SetAdmin == false then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ البوت ليس لديه صلاحيه اضافة مشرفين* ',"md",true)  
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Message_Reply.sender_id.user_id)
if UserInfo.message == "Invalid user ID" then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً تستطيع فقط استخدام الامر على المستخدمين ","md",true)  
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا تستطيع استخدام الامر على البوت ","md",true)  
end
local SetAdmin = bot.setChatMemberStatus(msg.chat_id,Message_Reply.sender_id.user_id,'administrator',{1 ,1, 0, 0, 0, 0, 0 , 0, 0, 0, 0, 0, ''})
if SetAdmin.code == 3 then
return bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ لا يمكنني رفعه ليس لدي صلاحيات *","md",true)  
end
https.request("https://api.telegram.org/bot" .. Token .. "/promoteChatMember?chat_id=" .. msg.chat_id .. "&user_id=" ..Message_Reply.sender_id.user_id.."&&can_manage_voice_chats=true")
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '‹ تعديل الصلاحيات ›', data = msg.sender_id.user_id..'/groupNumseteng//'..Message_Reply.sender_id.user_id}, 
},
}
}
return bot.sendText(msg.chat_id, msg.id, "⤈︙  تم رفعه مشرف بنجاح . ", 'md', false, false, false, false, reply_markup)
end
if text and text:match('^رفع مشرف @(%S+)$') then
local UserName = text:match('^رفع مشرف @(%S+)$')
if not programmer(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المنشئ* ',"md",true)  
end
if msg.can_be_deleted_for_all_users == false then
return bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذراً البوت ليس ادمن في المجموعه يرجى رفعه وتفعيل الصلاحيات له *","md",true)  
end
if GetInfoBot(msg).SetAdmin == false then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ البوت ليس لديه صلاحيه اضافة مشرفين* ',"md",true)  
end
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا يوجد حساب بهذا المعرف ","md",true)  
end
if UserId_Info.type.is_channel == true then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا تستطيع استخدام معرف قناة او كروب ","md",true)  
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا تستطيع استخدام معرف البوت ","md",true)  
end
local SetAdmin = bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'administrator',{1 ,1, 0, 0, 0, 0, 0 , 0, 0, 0, 0, 0, ''})
if SetAdmin.code == 3 then
return bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ لا يمكنني رفعه ليس لدي صلاحيات *","md",true)  
end
https.request("https://api.telegram.org/bot" .. Token .. "/promoteChatMember?chat_id=" .. msg.chat_id .. "&user_id=" ..UserId_Info.id.."&&can_manage_voice_chats=true")
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '‹ تعديل الصلاحيات ›', data = msg.sender_id.user_id..'/groupNumseteng//'..UserId_Info.id}, 
},
}
}
return bot.sendText(msg.chat_id, msg.id, "⤈︙  صلاحيات المستخدم .", 'md', false, false, false, false, reply_markup)
end 
if text == ('تنزيل مشرف') and msg.reply_to_message_id ~= 0 then
if not Constructor(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المنشئ* ',"md",true)  
end
if msg.can_be_deleted_for_all_users == false then
return bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذراً البوت ليس ادمن في المجموعه يرجى رفعه وتفعيل الصلاحيات له *","md",true)  
end
if GetInfoBot(msg).SetAdmin == false then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ البوت ليس لديه صلاحيه اضافة مشرفين* ',"md",true)  
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Message_Reply.sender_id.user_id)
if UserInfo.message == "Invalid user ID" then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً تستطيع فقط استخدام الامر على المستخدمين ","md",true)  
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا تستطيع استخدام الامر على البوت ","md",true)  
end
local SetAdmin = bot.setChatMemberStatus(msg.chat_id,Message_Reply.sender_id.user_id,'administrator',{0 ,0, 0, 0, 0, 0, 0 ,0, 0})
if SetAdmin.code == 400 then
return bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ لست انا من قام برفعه .*","md",true)  
end
if SetAdmin.code == 3 then
return bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ لا يمكنني تنزيله ليس لدي صلاحيات .*","md",true)  
end
return bot.sendText(msg.chat_id,msg.id,Reply_Status(Message_Reply.sender_id.user_id,"⤈︙ تم تنزيله من المشرفين بنجاح .").helo,"md",true)  
end
if text and text:match('^تنزيل مشرف @(%S+)$') then
local UserName = text:match('^تنزيل مشرف @(%S+)$')
if not Constructor(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المنشئ* ',"md",true)  
end
if msg.can_be_deleted_for_all_users == false then
return bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذراً البوت ليس ادمن في المجموعه يرجى رفعه وتفعيل الصلاحيات له *","md",true)  
end
if GetInfoBot(msg).SetAdmin == false then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ البوت ليس لديه صلاحيه اضافة مشرفين* ',"md",true)  
end
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا يوجد حساب بهذا المعرف ","md",true)  
end
if UserId_Info.type.is_channel == true then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا تستطيع استخدام معرف قناة او كروب ","md",true)  
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا تستطيع استخدام معرف البوت ","md",true)  
end
local SetAdmin = bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'administrator',{0 ,0, 0, 0, 0, 0, 0 ,0, 0})
if SetAdmin.code == 400 then
return bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ لست انا من قام برفعه .*","md",true)  
end
if SetAdmin.code == 3 then
return bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ لا يمكنني تنزيله ليس لدي صلاحيات *","md",true)  
end
return bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"⤈︙ تم تنزيله من المشرفين بنجاح .").helo,"md",true)  
end

if text and text:match('ضع لقب (.*)') and msg.reply_to_message_id ~= 0 then
local CustomTitle = text:match('ضع لقب (.*)')
if not Constructor(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المنشئ* ',"md",true)  
end
if msg.can_be_deleted_for_all_users == false then
return bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذراً البوت ليس ادمن او ليست لدي جميع الصلاحيات *","md",true)  
end
if GetInfoBot(msg).SetAdmin == false then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ البوت ليس لديه صلاحيه اضافة مشرفين* ',"md",true)  
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Message_Reply.sender_id.user_id)
if UserInfo.message == "Invalid user ID" then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً تستطيع فقط استخدام الامر على المستخدمين ","md",true)  
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا تستطيع استخدام الامر على البوت ","md",true)  
end
local SetCustomTitle = https.request("https://api.telegram.org/bot"..Token.."/setChatAdministratorCustomTitle?chat_id="..msg.chat_id.."&user_id="..Message_Reply.sender_id.user_id.."&custom_title="..CustomTitle)
local SetCustomTitle_ = JSON.decode(SetCustomTitle)
if SetCustomTitle_.result == true then
return bot.sendText(msg.chat_id,msg.id,Reply_Status(Message_Reply.sender_id.user_id,"⤈︙ رفعه لقبه : "..CustomTitle).heloo,"md",true)  
else
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً هناك خطا تاكد من البوت ومن الشخص","md",true)  
end 
end
if text and text:match('^ضع لقب @(%S+) (.*)$') then
local UserName = {text:match('^ضع لقب @(%S+) (.*)$')}
if not Constructor(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المنشئ* ',"md",true)  
end
if msg.can_be_deleted_for_all_users == false then
return bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذراً البوت ليس ادمن او ليست لدي جميع الصلاحيات *","md",true)  
end
if GetInfoBot(msg).SetAdmin == false then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ البوت ليس لديه صلاحيه اضافة مشرفين* ',"md",true)  
end
local UserId_Info = bot.searchPublicChat(UserName[1])
if not UserId_Info.id then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا يوجد حساب بهذا المعرف ","md",true)  
end
if UserId_Info.type.is_channel == true then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا تستطيع استخدام معرف قناة او كروب ","md",true)  
end
if UserName and UserName[1]:match('(%S+)[Bb][Oo][Tt]') then
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً لا تستطيع استخدام معرف البوت ","md",true)  
end
local SetCustomTitle = https.request("https://api.telegram.org/bot"..Token.."/setChatAdministratorCustomTitle?chat_id="..msg.chat_id.."&user_id="..UserId_Info.id.."&custom_title="..UserName[2])
local SetCustomTitle_ = JSON.decode(SetCustomTitle)
if SetCustomTitle_.result == true then
return bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"⤈︙ رفعه لقبه : "..UserName[2]).heloo,"md",true)  
else
return bot.sendText(msg.chat_id,msg.id,"\n⤈︙ عذراً هناك خطا تاكد من البوت ومن الشخص","md",true)  
end 
end 

if text == 'الرابط' or text == 'رابط' then
if not redis:get(bot_id.."Status:Link"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ الرابط معطل بواسطه المشرفين .","md",true)
end
Get_Chat = bot.getChat(msg.chat_id)
Info_Chats = bot.getSupergroupFullInfo(msg.chat_id)
if redis:get(bot_id..":"..msg.chat_id..":link") then
link = redis:get(bot_id..":"..msg.chat_id..":link")
else
if Info_Chats.invite_link.invite_link then
link = Info_Chats.invite_link.invite_link
else
link = "لا يوجد"
end
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = Get_Chat.title, url = link}},
}
}
bot.sendText(msg.chat_id,msg.id,"*⤈︙ Link Group : "..Get_Chat.title.."*\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"..link,"md",true, false, false, false, reply_markup)
return false
end
if text == "مسح رد انلاين" or text == "حذف رد انلاين" then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص الادمن* ',"md",true)  
end
    local reply_markup = bot.replyMarkup{
    type = 'inline',
    data = {
    {
    {text = '‹ الغاء ›', data = msg.sender_id.user_id..'/cancelamr'},
    },
    }
    }
    redis:set(bot_id.."Set:Manager:rd:inline"..msg.sender_id.user_id..":"..msg.chat_id,"true2")
    return bot.sendText(msg.chat_id,msg.id,"⤈︙ ارسل الان الكلمه لمسحها من الردود الانلاين","md",false, false, false, false, reply_markup)
    end 
  if text and text:match("^(.*)$") then
  if redis:get(bot_id.."Set:Manager:rd:inline"..msg.sender_id.user_id..":"..msg.chat_id.."") == "true2" then
    redis:del(bot_id.."Add:Rd:Manager:Gif:inline"..text..msg.chat_id)   
    redis:del(bot_id.."Add:Rd:Manager:Vico:inline"..text..msg.chat_id)   
    redis:del(bot_id.."Add:Rd:Manager:Stekrs:inline"..text..msg.chat_id)     
    redis:del(bot_id.."Add:Rd:Manager:Text:inline"..text..msg.chat_id)   
    redis:del(bot_id.."Add:Rd:Manager:Photo:inline"..text..msg.chat_id)
    redis:del(bot_id.."Add:Rd:Manager:Photoc:inline"..text..msg.chat_id)
    redis:del(bot_id.."Add:Rd:Manager:Video:inline"..text..msg.chat_id)
    redis:del(bot_id.."Add:Rd:Manager:Videoc:inline"..text..msg.chat_id)  
    redis:del(bot_id.."Add:Rd:Manager:File:inline"..text..msg.chat_id)
    redis:del(bot_id.."Add:Rd:Manager:video_note:inline"..text..msg.chat_id)
    redis:del(bot_id.."Add:Rd:Manager:Audio:inline"..text..msg.chat_id)
    redis:del(bot_id.."Add:Rd:Manager:Audioc:inline"..text..msg.chat_id)
    redis:del(bot_id.."Rd:Manager:inline:text"..text..msg.chat_id)
    redis:del(bot_id.."Rd:Manager:inline:link"..text..msg.chat_id)
  redis:del(bot_id.."Set:Manager:rd:inline"..msg.sender_id.user_id..":"..msg.chat_id.."")
  redis:srem(bot_id.."List:Manager:inline"..msg.chat_id.."", text)
  bot.sendText(msg.chat_id,msg.id,"⤈︙ تم مسح الرد من الردود الانلاين ","md",true)  
  return false
  end
  end
  if text == ("مسح الردود الانلاين") or text == ("حذف الردود الانلاين") then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ عذراً الامر يخص الادمن فقط .* ',"md",true)  
end
    local list = redis:smembers(bot_id.."List:Manager:inline"..msg.chat_id.."")
    for k,v in pairs(list) do
        redis:del(bot_id.."Add:Rd:Manager:Gif:inline"..v..msg.chat_id)   
        redis:del(bot_id.."Add:Rd:Manager:Vico:inline"..v..msg.chat_id)   
        redis:del(bot_id.."Add:Rd:Manager:Stekrs:inline"..v..msg.chat_id)     
        redis:del(bot_id.."Add:Rd:Manager:Text:inline"..v..msg.chat_id)   
        redis:del(bot_id.."Add:Rd:Manager:Photo:inline"..v..msg.chat_id)
        redis:del(bot_id.."Add:Rd:Manager:Photoc:inline"..v..msg.chat_id)
        redis:del(bot_id.."Add:Rd:Manager:Video:inline"..v..msg.chat_id)
        redis:del(bot_id.."Add:Rd:Manager:Videoc:inline"..v..msg.chat_id)  
        redis:del(bot_id.."Add:Rd:Manager:File:inline"..v..msg.chat_id)
        redis:del(bot_id.."Add:Rd:Manager:video_note:inline"..v..msg.chat_id)
        redis:del(bot_id.."Add:Rd:Manager:Audio:inline"..v..msg.chat_id)
        redis:del(bot_id.."Add:Rd:Manager:Audioc:inline"..v..msg.chat_id)
        redis:del(bot_id.."Rd:Manager:inline:v"..v..msg.chat_id)
        redis:del(bot_id.."Rd:Manager:inline:link"..v..msg.chat_id)
    redis:del(bot_id.."List:Manager:inline"..msg.chat_id)
    end
    return bot.sendText(msg.chat_id,msg.id,"⤈︙ تم مسح قائمه ردود الانلاين","md",true)  
    end
  if text == "اضف رد انلاين" then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص الادمن* ',"md",true)  
end
    redis:set(bot_id.."Set:Manager:rd:inline"..msg.sender_id.user_id..":"..msg.chat_id,true)
    local reply_markup = bot.replyMarkup{
    type = 'inline',
    data = {
    {
    {text = '‹ الغاء ›', data = msg.sender_id.user_id..'/cancelamr'},
    },
    }
    }
    return bot.sendText(msg.chat_id,msg.id,"⤈︙ ارسل الان الكلمه لاضافتها في ردود الانلاين ","md",false, false, false, false, reply_markup)
  end
  if text and text:match("^(.*)$") and tonumber(msg.sender_id.user_id) ~= tonumber(bot_id) then
    if redis:get(bot_id.."Set:Manager:rd:inline"..msg.sender_id.user_id..":"..msg.chat_id) == "true" then
    redis:set(bot_id.."Set:Manager:rd:inline"..msg.sender_id.user_id..":"..msg.chat_id,"true1")
    redis:set(bot_id.."Text:Manager:inline"..msg.sender_id.user_id..":"..msg.chat_id, text)
    redis:del(bot_id.."Add:Rd:Manager:Gif:inline"..text..msg.chat_id)   
    redis:del(bot_id.."Add:Rd:Manager:Vico:inline"..text..msg.chat_id)   
    redis:del(bot_id.."Add:Rd:Manager:Stekrs:inline"..text..msg.chat_id)     
    redis:del(bot_id.."Add:Rd:Manager:Text:inline"..text..msg.chat_id)   
    redis:del(bot_id.."Add:Rd:Manager:Photo:inline"..text..msg.chat_id)
    redis:del(bot_id.."Add:Rd:Manager:Photoc:inline"..text..msg.chat_id)
    redis:del(bot_id.."Add:Rd:Manager:Video:inline"..text..msg.chat_id)
    redis:del(bot_id.."Add:Rd:Manager:Videoc:inline"..text..msg.chat_id)  
    redis:del(bot_id.."Add:Rd:Manager:File:inline"..text..msg.chat_id)
    redis:del(bot_id.."Add:Rd:Manager:video_note:inline"..text..msg.chat_id)
    redis:del(bot_id.."Add:Rd:Manager:Audio:inline"..text..msg.chat_id)
    redis:del(bot_id.."Add:Rd:Manager:Audioc:inline"..text..msg.chat_id)
    redis:del(bot_id.."Rd:Manager:inline:text"..text..msg.chat_id)
    redis:del(bot_id.."Rd:Manager:inline:link"..text..msg.chat_id)
    redis:sadd(bot_id.."List:Manager:inline"..msg.chat_id.."", text)
    bot.sendText(msg.chat_id,msg.id,[[
    ⤈︙ ارسل لي الرد سواء اكان
    ❨ ملف ، ملصق ، متحركه ، صوره
     ، فيديو ، بصمه الفيديو ، بصمه ، صوت ، رساله ❩
    ⤈︙ يمكنك اضافة :
    ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
     `#name` ↬ اسم المستخدم
     `#username` ↬ معرف المستخدم
     `#msgs` ↬ عدد الرسائل
     `#id` ↬ ايدي المستخدم
     `#stast` ↬ رتبة المستخدم
     `#edit` ↬ عدد التعديلات
    
    ]],"md",true)  
    return false
    end
    end

  if text and redis:get(bot_id.."Set:Manager:rd:inline"..msg.sender_id.user_id..":"..msg.chat_id) == "set_inline" then
  redis:set(bot_id.."Set:Manager:rd:inline"..msg.sender_id.user_id..":"..msg.chat_id, "set_link")
  local anubis = redis:get(bot_id.."Text:Manager:inline"..msg.sender_id.user_id..":"..msg.chat_id)
  redis:set(bot_id.."Rd:Manager:inline:text"..anubis..msg.chat_id, text)
  bot.sendText(msg.chat_id,msg.id,"⤈︙ الان ارسل الرابط","md",true)  
  return false  
  end
  if text and redis:get(bot_id.."Set:Manager:rd:inline"..msg.sender_id.user_id..":"..msg.chat_id) == "set_link" then
  redis:del(bot_id.."Set:Manager:rd:inline"..msg.sender_id.user_id..":"..msg.chat_id)
  local anubis = redis:get(bot_id.."Text:Manager:inline"..msg.sender_id.user_id..":"..msg.chat_id)
  redis:set(bot_id.."Rd:Manager:inline:link"..anubis..msg.chat_id, text)
  bot.sendText(msg.chat_id,msg.id,"⤈︙ تم اضافه الرد بنجاح","md",true)  
  return false  
  end
  if text and not redis:get(bot_id.."Status:Reply:inline"..msg.chat_id) then
  local btext = redis:get(bot_id.."Rd:Manager:inline:text"..text..msg.chat_id)
  local blink = redis:get(bot_id.."Rd:Manager:inline:link"..text..msg.chat_id)
  local anemi = redis:get(bot_id.."Add:Rd:Manager:Gif:inline"..text..msg.chat_id)   
  local veico = redis:get(bot_id.."Add:Rd:Manager:Vico:inline"..text..msg.chat_id)   
  local stekr = redis:get(bot_id.."Add:Rd:Manager:Stekrs:inline"..text..msg.chat_id)     
  local Texingt = redis:get(bot_id.."Add:Rd:Manager:Text:inline"..text..msg.chat_id)   
  local photo = redis:get(bot_id.."Add:Rd:Manager:Photo:inline"..text..msg.chat_id)
  local photoc = redis:get(bot_id.."Add:Rd:Manager:Photoc:inline"..text..msg.chat_id)
  local video = redis:get(bot_id.."Add:Rd:Manager:Video:inline"..text..msg.chat_id)
  local videoc = redis:get(bot_id.."Add:Rd:Manager:Videoc:inline"..text..msg.chat_id)  
  local document = redis:get(bot_id.."Add:Rd:Manager:File:inline"..text..msg.chat_id)
  local audio = redis:get(bot_id.."Add:Rd:Manager:Audio:inline"..text..msg.chat_id)
  local audioc = redis:get(bot_id.."Add:Rd:Manager:Audioc:inline"..text..msg.chat_id)
  local video_note = redis:get(bot_id.."Add:Rd:Manager:video_note:inline"..text..msg.chat_id)
  local reply_markup = bot.replyMarkup{
    type = 'inline',
    data = {
    {
    {text = btext , url = blink},
    },
    }
    }
  if Texingt then 
  local UserInfo = bot.getUser(msg.sender_id.user_id)
  local NumMsg = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":message") or 1
  local TotalMsg = Total_message(NumMsg) 
  local Status_Gps = Get_Rank(msg.sender_id.user_id,msg.chat_id)
  local NumMessageEdit = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Editmessage") or 0
  local Texingt = Texingt:gsub('#username',(UserInfo.username or 'لا يوجد')) 
  local Texingt = Texingt:gsub('#name',UserInfo.first_name)
  local Texingt = Texingt:gsub('#id',msg.sender_id.user_id)
  local Texingt = Texingt:gsub('#edit',NumMessageEdit)
  local Texingt = Texingt:gsub('#msgs',NumMsg)
  local Texingt = Texingt:gsub('#stast',Status_Gps)
  bot.sendText(msg.chat_id,msg.id,'['..Texingt..']',"md",false, false, false, false, reply_markup)  
  end
  if video_note then
  bot.sendVideoNote(msg.chat_id, msg.id, video_note, nil, nil, nil, nil, nil, nil, nil, reply_markup)
  end
  if photo then
  bot.sendPhoto(msg.chat_id, msg.id, photo,photoc,"md", true, nil, nil, nil, nil, nil, nil, nil, nil, reply_markup )
  end  
  if stekr then 
  bot.sendSticker(msg.chat_id, msg.id, stekr,nil,nil,nil,nil,nil,nil,nil,reply_markup)
  end
  if veico then 
  bot.sendVoiceNote(msg.chat_id, msg.id, veico, '', 'md',nil, nil, nil, nil, reply_markup)
  end
  if video then 
  bot.sendVideo(msg.chat_id, msg.id, video, videoc, "md", true, nil, nil, nil, nil, nil, nil, nil, nil, nil, reply_markup)
  end
  if anemi then 
  bot.sendAnimation(msg.chat_id,msg.id, anemi, '', 'md', nil, nil, nil, nil, nil, nil, nil, nil,reply_markup)
  end
  if document then
  bot.sendDocument(msg.chat_id, msg.id, document, '', 'md',nil, nil, nil, nil,nil, reply_markup)
  end  
  if audio then
  bot.sendAudio(msg.chat_id, msg.id, audio, audioc, "md", nil, nil, nil, nil, nil, nil, nil, nil,reply_markup) 
  end
  end
  if text == ("الردود الانلاين") then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص الادمن* ',"md",true)  
end
    local list = redis:smembers(bot_id.."List:Manager:inline"..msg.chat_id.."")
    text = "⤈︙ قائمه الردود الانلاين \nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
    for k,v in pairs(list) do
    if redis:get(bot_id.."Add:Rd:Manager:Gif:inline"..v..msg.chat_id) then
    db = "متحركه 🎭"
    elseif redis:get(bot_id.."Add:Rd:Manager:Vico:inline"..v..msg.chat_id) then
    db = "بصمه 📢"
    elseif redis:get(bot_id.."Add:Rd:Manager:Stekrs:inline"..v..msg.chat_id) then
    db = "ملصق 🃏"
    elseif redis:get(bot_id.."Add:Rd:Manager:Text:inline"..v..msg.chat_id) then
    db = "رساله ✉"
    elseif redis:get(bot_id.."Add:Rd:Manager:Photo:inline"..v..msg.chat_id) then
    db = "صوره 🎇"
    elseif redis:get(bot_id.."Add:Rd:Manager:Video:inline"..v..msg.chat_id) then
    db = "فيديو 📹"
    elseif redis:get(bot_id.."Add:Rd:Manager:File:inline"..v..msg.chat_id) then
    db = "ملف ⤈︙"
    elseif redis:get(bot_id.."Add:Rd:Manager:Audio:inline"..v..msg.chat_id) then
    db = "اغنيه 🎵"
    elseif redis:get(bot_id.."Add:Rd:Manager:video_note:inline"..v..msg.chat_id) then
    db = "بصمه فيديو 🎥"
    end
    text = text..""..k.." » (" ..v.. ") » (" ..db.. ")\n"
    end
    if #list == 0 then
    text = "⤈︙ عذرا لا يوجد ردود انلاين في الكروب"
    end
    return bot.sendText(msg.chat_id,msg.id,"["..text.."]","md",true)  
    end
------------------------
if text == "مسح رد انلاين عام" or text == "مسح رد عام انلاين" then
if not programmer(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المطور الثانوي* ',"md",true)  
end
    local reply_markup = bot.replyMarkup{
    type = 'inline',
    data = {
    {
    {text = '‹ الغاء ›', data = msg.sender_id.user_id..'/cancelamr'},
    },
    }
    }
    redis:set(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender_id.user_id..":"..msg.chat_id,"true2")
    return bot.sendText(msg.chat_id,msg.id,"⤈︙ ارسل الان الكلمه لمسحها من الردود الانلاين العامه","md",false, false, false, false, reply_markup)
    end 
  if text and text:match("^(.*)$") then
  if redis:get(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender_id.user_id..":"..msg.chat_id.."") == "true2" then
    redis:del(bot_id.."Addd:Rdd:Managerr:Giff:inlinee"..text)   
    redis:del(bot_id.."Addd:Rdd:Managerr:Vicoo:inlinee"..text)   
    redis:del(bot_id.."Addd:Rdd:Managerr:Stekrss:inlinee"..text)     
    redis:del(bot_id.."Addd:Rdd:Managerr:Textt:inlinee"..text)   
    redis:del(bot_id.."Addd:Rdd:Managerr:Photoo:inlinee"..text)
    redis:del(bot_id.."Addd:Rdd:Managerr:Photocc:inlinee"..text)
    redis:del(bot_id.."Addd:Rdd:Managerr:Videoo:inlinee"..text)
    redis:del(bot_id.."Addd:Rdd:Managerr:Videocc:inlinee"..text)  
    redis:del(bot_id.."Addd:Rdd:Managerr:Filee:inlinee"..text)
    redis:del(bot_id.."Addd:Rdd:Managerr:video_notee:inlinee"..text)
    redis:del(bot_id.."Addd:Rdd:Managerr:Audioo:inlinee"..text)
    redis:del(bot_id.."Addd:Rdd:Managerr:Audiocc:inlinee"..text)
    redis:del(bot_id.."Rdd:Managerr:inlinee:textt"..text)
    redis:del(bot_id.."Rdd:Managerr:inlinee:linkk"..text)
  redis:del(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender_id.user_id..":"..msg.chat_id.."")
  redis:srem(bot_id.."Listt:Managerr:inlinee", text)
  bot.sendText(msg.chat_id,msg.id,"⤈︙ تم مسح الرد من الردود الانلاين العامه","md",true)  
  return false
  end
  end
  if text == ("مسح الردود الانلاين العامه") then
if not programmer(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المطور الثانوي* ',"md",true)  
end
    local list = redis:smembers(bot_id.."Listt:Managerr:inlinee")
    for k,v in pairs(list) do
        redis:del(bot_id.."Addd:Rdd:Managerr:Giff:inlinee"..v)   
        redis:del(bot_id.."Addd:Rdd:Managerr:Vicoo:inlinee"..v)   
        redis:del(bot_id.."Addd:Rdd:Managerr:Stekrss:inlinee"..v)     
        redis:del(bot_id.."Addd:Rdd:Managerr:Textt:inlinee"..v)   
        redis:del(bot_id.."Addd:Rdd:Managerr:Photoo:inlinee"..v)
        redis:del(bot_id.."Addd:Rdd:Managerr:Photocc:inlinee"..v)
        redis:del(bot_id.."Addd:Rdd:Managerr:Videoo:inlinee"..v)
        redis:del(bot_id.."Addd:Rdd:Managerr:Videocc:inlinee"..v)  
        redis:del(bot_id.."Addd:Rdd:Managerr:Filee:inlinee"..v)
        redis:del(bot_id.."Addd:Rdd:Managerr:video_notee:inlinee"..v)
        redis:del(bot_id.."Addd:Rdd:Managerr:Audioo:inlinee"..v)
        redis:del(bot_id.."Add:Rd:Manager:Audiocc:inlinee"..v)
        redis:del(bot_id.."Rdd:Managerr:inlinee:vv"..v)
        redis:del(bot_id.."Rdd:Managerr:inlinee:linkk"..v)
    redis:del(bot_id.."Listt:Managerr:inlinee")
    end
    return bot.sendText(msg.chat_id,msg.id,"⤈︙ تم مسح قائمه ردود الانلاين العامه","md",true)  
    end
  if text == "اضف رد انلاين عام" or text == "اضف رد عام انلاين" then
if not programmer(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المطور الثانوي* ',"md",true)  
end
    redis:set(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender_id.user_id..":"..msg.chat_id,true)
    local reply_markup = bot.replyMarkup{
    type = 'inline',
    data = {
    {
    {text = '‹ الغاء ›', data = msg.sender_id.user_id..'/cancelamr'},
    },
    }
    }
    return bot.sendText(msg.chat_id,msg.id,"⤈︙ ارسل الان الكلمه لاضافتها في ردود الانلاين العامه","md",false, false, false, false, reply_markup)
  end
  if text and text:match("^(.*)$") and tonumber(msg.sender_id.user_id) ~= tonumber(bot_id) then
    if redis:get(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender_id.user_id..":"..msg.chat_id) == "true" then
    redis:set(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender_id.user_id..":"..msg.chat_id,"true1")
    redis:set(bot_id.."Textt:Managerr:inlinee"..msg.sender_id.user_id.."", text)
    redis:del(bot_id.."Addd:Rdd:Managerr:Giff:inlinee"..text)   
    redis:del(bot_id.."Addd:Rdd:Managerr:Vicoo:inlinee"..text)   
    redis:del(bot_id.."Addd:Rdd:Managerr:Stekrss:inlinee"..text)     
    redis:del(bot_id.."Addd:Rdd:Managerr:Textt:inlinee"..text)   
    redis:del(bot_id.."Addd:Rdd:Managerr:Photoo:inlinee"..text)
    redis:del(bot_id.."Addd:Rdd:Managerr:Photocc:inlinee"..text)
    redis:del(bot_id.."Addd:Rdd:Managerr:Videoo:inlinee"..text)
    redis:del(bot_id.."Addd:Rdd:Managerr:Videocc:inlinee"..text)  
    redis:del(bot_id.."Addd:Rdd:Managerr:Filee:inlinee"..text)
    redis:del(bot_id.."Addd:Rdd:Managerr:video_notee:inlinee"..text)
    redis:del(bot_id.."Addd:Rdd:Managerr:Audioo:inlinee"..text)
    redis:del(bot_id.."Addd:Rdd:Managerr:Audiocc:inlinee"..text)
    redis:del(bot_id.."Rdd:Managerr:inlinee:textt"..text)
    redis:del(bot_id.."Rdd:Managerr:inlinee:linkk"..text)
    redis:sadd(bot_id.."Listt:Managerr:inlinee", text)
    bot.sendText(msg.chat_id,msg.id,[[
    ⤈︙ ارسل لي الرد سواء اكان
    ❨ ملف ، ملصق ، متحركه ، صوره
     ، فيديو ، بصمه الفيديو ، بصمه ، صوت ، رساله ❩
    ⤈︙ يمكنك اضافة :
    ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉
     `#name` ↬ اسم المستخدم
     `#username` ↬ معرف المستخدم
     `#msgs` ↬ عدد الرسائل
     `#id` ↬ ايدي المستخدم
     `#stast` ↬ رتبة المستخدم
     `#edit` ↬ عدد التعديلات
    
    ]],"md",true)  
    return false
    end
    end

  if text and redis:get(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender_id.user_id..":"..msg.chat_id) == "set_inlinee" then
  redis:set(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender_id.user_id..":"..msg.chat_id, "set_linkk")
  local anubis = redis:get(bot_id.."Textt:Managerr:inlinee"..msg.sender_id.user_id)
  redis:set(bot_id.."Rdd:Managerr:inlinee:textt"..anubis, text)
  bot.sendText(msg.chat_id,msg.id,"⤈︙ الان ارسل الرابط","md",true)  
  return false  
  end
  if text and redis:get(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender_id.user_id..":"..msg.chat_id) == "set_linkk" then
  redis:del(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender_id.user_id..":"..msg.chat_id)
  local anubis = redis:get(bot_id.."Textt:Managerr:inlinee"..msg.sender_id.user_id)
  redis:set(bot_id.."Rdd:Managerr:inlinee:linkk"..anubis, text)
  bot.sendText(msg.chat_id,msg.id,"⤈︙ تم اضافه الرد بنجاح","md",true)  
  return false  
  end
  if text and not redis:get(bot_id.."Statuss:Replyy:inlinee"..msg.chat_id) then
  local btext = redis:get(bot_id.."Rdd:Managerr:inlinee:textt"..text)
  local blink = redis:get(bot_id.."Rdd:Managerr:inlinee:linkk"..text)
  local anemi = redis:get(bot_id.."Addd:Rdd:Managerr:Giff:inlinee"..text)   
  local veico = redis:get(bot_id.."Addd:Rdd:Managerr:Vicoo:inlinee"..text)   
  local stekr = redis:get(bot_id.."Addd:Rdd:Managerr:Stekrss:inlinee"..text)     
  local Texingt = redis:get(bot_id.."Addd:Rdd:Managerr:Textt:inlinee"..text)   
  local photo = redis:get(bot_id.."Addd:Rdd:Managerr:Photoo:inlinee"..text)
  local photoc = redis:get(bot_id.."Addd:Rdd:Managerr:Photocc:inlinee"..text)
  local video = redis:get(bot_id.."Addd:Rdd:Managerr:Videoo:inlinee"..text)
  local videoc = redis:get(bot_id.."Addd:Rdd:Managerr:Videocc:inlinee"..text)  
  local document = redis:get(bot_id.."Addd:Rdd:Managerr:Filee:inlinee"..text)
  local audio = redis:get(bot_id.."Addd:Rdd:Managerr:Audioo:inlinee"..text)
  local audioc = redis:get(bot_id.."Addd:Rdd:Managerr:Audiocc:inlinee"..text)
  local video_note = redis:get(bot_id.."Addd:Rdd:Managerr:video_notee:inlinee"..text)
  local reply_markup = bot.replyMarkup{
    type = 'inline',
    data = {
    {
    {text = btext , url = blink},
    },
    }
    }
  if Texingt then 
  local UserInfo = bot.getUser(msg.sender_id.user_id)
  local NumMsg = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":message") or 1
  local TotalMsg = Total_message(NumMsg) 
  local Status_Gps = Get_Rank(msg.sender_id.user_id,msg.chat_id)
  local NumMessageEdit = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Editmessage") or 0
  local Texingt = Texingt:gsub('#username',(UserInfo.username or 'لا يوجد')) 
  local Texingt = Texingt:gsub('#name',UserInfo.first_name)
  local Texingt = Texingt:gsub('#id',msg.sender_id.user_id)
  local Texingt = Texingt:gsub('#edit',NumMessageEdit)
  local Texingt = Texingt:gsub('#msgs',NumMsg)
  local Texingt = Texingt:gsub('#stast',Status_Gps)
  bot.sendText(msg.chat_id,msg.id,'['..Texingt..']',"md",false, false, false, false, reply_markup)  
  end
  if video_note then
  bot.sendVideoNote(msg.chat_id, msg.id, video_note, nil, nil, nil, nil, nil, nil, nil, reply_markup)
  end
  if photo then
  bot.sendPhoto(msg.chat_id, msg.id, photo,photoc,"md", true, nil, nil, nil, nil, nil, nil, nil, nil, reply_markup )
  end  
  if stekr then 
  bot.sendSticker(msg.chat_id, msg.id, stekr,nil,nil,nil,nil,nil,nil,nil,reply_markup)
  end
  if veico then 
  bot.sendVoiceNote(msg.chat_id, msg.id, veico, '', 'md',nil, nil, nil, nil, reply_markup)
  end
  if video then 
  bot.sendVideo(msg.chat_id, msg.id, video, videoc, "md", true, nil, nil, nil, nil, nil, nil, nil, nil, nil, reply_markup)
  end
  if anemi then 
  bot.sendAnimation(msg.chat_id,msg.id, anemi, '', 'md', nil, nil, nil, nil, nil, nil, nil, nil,reply_markup)
  end
  if document then
  bot.sendDocument(msg.chat_id, msg.id, document, '', 'md',nil, nil, nil, nil,nil, reply_markup)
  end  
  if audio then
  bot.sendAudio(msg.chat_id, msg.id, audio, audioc, "md", nil, nil, nil, nil, nil, nil, nil, nil,reply_markup) 
  end
  end
  if text == ("الردود الانلاين العامه") then
if not programmer(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المطور الثانوي* ',"md",true)  
end
    local list = redis:smembers(bot_id.."Listt:Managerr:inlinee")
    text = "⤈︙ قائمه الردود الانلاين العامه \nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
    for k,v in pairs(list) do
    if redis:get(bot_id.."Addd:Rdd:Managerr:Giff:inlinee"..v) then
    db = "متحركه 🎭"
    elseif redis:get(bot_id.."Addd:Rdd:Managerr:Vicoo:inlinee"..v) then
    db = "بصمه 📢"
    elseif redis:get(bot_id.."Addd:Rdd:Managerr:Stekrss:inlinee"..v) then
    db = "ملصق 🃏"
    elseif redis:get(bot_id.."Addd:Rdd:Managerr:Textt:inlinee"..v) then
    db = "رساله ✉"
    elseif redis:get(bot_id.."Addd:Rdd:Managerr:Photoo:inlinee"..v) then
    db = "صوره 🎇"
    elseif redis:get(bot_id.."Addd:Rdd:Managerr:Videoo:inlinee"..v) then
    db = "فيديو ??"
    elseif redis:get(bot_id.."Addd:Rdd:Managerr:Filee:inlinee"..v) then
    db = "ملف ⤈︙"
    elseif redis:get(bot_id.."Addd:Rdd:Managerr:Audioo:inlinee"..v) then
    db = "اغنيه 🎵"
    elseif redis:get(bot_id.."Addd:Rdd:Managerr:video_notee:inlinee"..v) then
    db = "بصمه فيديو 🎥"
    end
    text = text..""..k.." » (" ..v.. ") » (" ..db.. ")\n"
    end
    if #list == 0 then
    text = "⤈︙ عذرا لا يوجد ردود انلاين عامه"
    end
    return bot.sendText(msg.chat_id,msg.id,"["..text.."]","md",true)  
    end
----------------
if text == 'الكروب' or text == 'عدد الكروب' or text == 'عدد الكروب' then
Get_Chat = bot.getChat(msg.chat_id)
Info_Chats = bot.getSupergroupFullInfo(msg.chat_id)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = Get_Chat.title, url = Info_Chats.invite_link.invite_link}},
}
}
bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ معلومات الكروب :\n⤈︙ الايدي ↢ '..msg.chat_id..' \n⤈︙ عدد الاعضاء ↢ '..Info_Chats.member_count..'\n⤈︙ عدد الادمنيه ↢ '..Info_Chats.administrator_count..'\n⤈︙ عدد المطرودين ↢ '..Info_Chats.banned_count..'\n⤈︙ عدد المقيدين ↢ '..Info_Chats.restricted_count..'\n⤈︙ الرابط\n : '..Info_Chats.invite_link.invite_link..'*',"md",true, false, false, false, reply_markup)
return false
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:gameVip") then
if text == 'الالعاب الاحترافيه' and Vips(msg)  then
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text=" لعبة فلابي بيرد ⌁ ",url='https://t.me/awesomebot?game=FlappyBird'}},
{{text= " موتسيكلات ⌁ ",url='https://t.me/gamee?game=MotoFx'},{text=" تبديل الاشكال ⌁",url='https://t.me/gamee?game=DiamondRows'}},
{{text=" كرة القدم ⌁ ",url='https://t.me/gamee?game=FootballStar'},{text=" اطلاق النار ⌁ ",url='https://t.me/gamee?game=NeonBlaster'}},
{{text=" دومينو ⌁ ",url='https://vipgames.com/play/?affiliateId=wpDom/#/games/domino/lobby'},{text=" ليدو ⌁ ",url='https://vipgames.com/play/?affiliateId=wpVG#/games/ludo/lobby'}},
{{text=" الورق ⌁ ",url='https://t.me/gamee?game=Hexonix'}},
{{text="تحداني في اكس اوو ⌁",url='t.me/XO_AABOT?start3836619'}},
{{text=" 2048 ⌁ ",url='https://t.me/awesomebot?game=g2048'},{text=" مربعات ⌁ ",url='https://t.me/gamee?game=Squares'}},
{{text=" القفز ⌁  ",url='https://t.me/gamee?game=AtomicDrop1'},{text=" القرصان ⌁ ",url='https://t.me/gamebot?game=Corsairs'}},
{{text=" تقطيع الاشجار ⌁ ",url='https://t.me/gamebot?game=LumberJack'}},
{{text=" الطائرة الصغيره ⌁ ",url='https://t.me/gamee?game=LittlePlane'},{text=" كرة الديسكو ⌁ ",url='https://t.me/gamee?game=RollerDisco'}},
}
}
bot.sendText(msg.chat_id,msg.id,'*⤈︙ قائمه الالعاب الاحترافيه اضغط للعب .*',"md", true, false, false, false, reply_markup)
end
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:entertainment") then
if text == "زواج" and msg.reply_to_message_id ~= 0 then
Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo1 = bot.getUser(msg.sender_id.user_id)
local UserInfo = bot.getUser(Remsg.sender_id.user_id)
if UserInfo1.id and UserInfo.id then  
if UserInfo.username and UserInfo.username ~= "" then
us1 = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
else
us1 = '['..UserInfo.first_name..'](tg://user?id='..UserInfo.id..')'
end
if UserInfo1.username and UserInfo1.username ~= "" then
us = '['..UserInfo1.first_name..'](t.me/'..UserInfo1.username..')'
else
us = '['..UserInfo1.first_name..'](tg://user?id='..UserInfo1.id..')'
end
if tonumber(redis:get(bot_id..":"..msg.chat_id..":marriage:"..msg.sender_id.user_id)) == tonumber(Remsg.sender_id.user_id) or tonumber(redis:get(bot_id..":"..msg.chat_id..":marriage:"..Remsg.sender_id.user_id)) == tonumber(msg.sender_id.user_id) then
return bot.sendText(msg.chat_id,msg.id,"*⤈︙ هي زوجتك بالفعل .*","md",true)
end
if redis:get(bot_id..":"..msg.chat_id..":marriage:"..Remsg.sender_id.user_id) then
return bot.sendText(msg.chat_id,msg.id,"*⤈︙ عزيزي/تي* ‹ "..us.." › \n*⤈︙ الشخص متزوج سابقا .*","md",true)
end
if redis:get(bot_id..":"..msg.chat_id..":marriage:"..msg.sender_id.user_id) then
return bot.sendText(msg.chat_id,msg.id,"*⤈︙ طلق الاولى بعدين اتزوج ثانيه .*","md",true)
end
local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '‹ قبول ›', data = "marriage_"..msg.sender_id.user_id.."_"..UserInfo.id.."_"..msg.id.."_OK"},{text = '‹ رفض ›', data ="marriage_"..msg.sender_id.user_id.."_"..UserInfo.id.."_"..msg.id.."_No"}}}}
return bot.sendText(msg.chat_id,msg.reply_to_message_id,"*⤈︙ عزيزي/تي* ‹ "..us1.." › \n*⤈︙ يوجد عرض زواج مقدم لك من قبل*\n ‹ "..us.." ›","md",true, false, false, false, reply_markup)
end
end
if text == 'زوجي'  or text == 'زوجتي' and msg.reply_to_message_id == 0 then
mrd = redis:get(bot_id..":"..msg.chat_id..":marriage:"..msg.sender_id.user_id) 
if mrd then
if text == 'زوجي' then
lj = "*زوجج هو*"
elseif text == 'زوجتي' then
lj = "*زوجتك هي*"
end
local UserInfo1 = bot.getUser(mrd)
if UserInfo1.username and UserInfo1.username ~= "" then
us = '['..UserInfo1.first_name..'](t.me/'..UserInfo1.username..')'
else
us = '['..UserInfo1.first_name..'](tg://user?id='..UserInfo1.id..')'
end
the = "⤈︙ "..lj.." "..us.." ."
else
the = "⤈︙ انت غير متزوج ."
end
bot.sendText(msg.chat_id,msg.id,the,"md",true)
return false
end
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:entertainment") then
if text == "طلاق" and msg.reply_to_message_id ~= 0 then
Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if tonumber(redis:get(bot_id..":"..msg.chat_id..":marriage:"..msg.sender_id.user_id)) == tonumber(Remsg.sender_id.user_id) or tonumber(redis:get(bot_id..":"..msg.chat_id..":marriage:"..Remsg.sender_id.user_id)) == tonumber(msg.sender_id.user_id) then
redis:srem(bot_id..":"..msg.chat_id.."couples",Remsg.sender_id.user_id) 
redis:srem(bot_id..":"..msg.chat_id.."wives",Remsg.sender_id.user_id) 
redis:srem(bot_id..":"..msg.chat_id.."couples",msg.sender_id.user_id) 
redis:srem(bot_id..":"..msg.chat_id.."wives",msg.sender_id.user_id) 
redis:del(bot_id..":"..msg.chat_id..":marriage:"..msg.sender_id.user_id)
redis:del(bot_id..":"..msg.chat_id..":marriage:"..Remsg.sender_id.user_id) 
ythr = "*⤈︙ تم طلاقكم بنجاح .*"
else
ythr = "*⤈︙ لا يمكنك تطليقها من زوجها  .*"
end
bot.sendText(msg.chat_id,msg.id,ythr,"md",true)  
return false
end  
end
if text == "trnd" or text == "الترند" or text == "ترند" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ Source Time ›',url="https://t.me/YAYYYYYY"}}
}
}
if not redis:get(bot_id.."userTypeRegular"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ الترند معطل بواسطه المشرفين .","md",true)
end
Info_User = bot.getUser(msg.sender_id.user_id) 
if Info_User.type.luatele == "userTypeRegular" then
GroupAllRtba = redis:hgetall(bot_id..':User:Count:'..msg.chat_id)
GetAllNames = redis:hgetall(bot_id..':User:Name:'..msg.chat_id)
GroupAllRtbaL = {}
for k,v in pairs(GroupAllRtba) do
table.insert(GroupAllRtbaL,{v,k})
end
Count,Kount,i = 8 , 0 , 1
for _ in pairs(GroupAllRtbaL) do 
Kount = Kount + 1 
end
table.sort(GroupAllRtbaL,function(a, b)
return tonumber(a[1]) > tonumber(b[1]) end)
if Count >= Kount then
Count = Kount 
end
Text = "*⤈︙ أكثر "..Count.." أعضاء تفاعلاً في المجموعة .*\n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"
for k,v in ipairs(GroupAllRtbaL) do
if i <= Count then
if i==1 then 
t="🥇"
elseif i==2 then
t="🥈" 
elseif i==3 then
 t="🥉" 
elseif i==4 then
 t="??" 
else 
t="🎖" 
end 
Text = Text..i..": ["..(GetAllNames[v[2]] or "خطأ بالاسم").."](tg://user?id="..v[2]..") : < *"..v[1].."* > "..t.."\n"
end
i=i+1
end
return bot.sendText(msg.chat_id,msg.id,Text,"md",true, false, false, false, reply_markup)
end
end
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":settings:decor") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":settings:decor") 
zh = https.request('https://black-source.xyz/BlackTeAM/frills.php?en='..URL.escape(text))
zx = JSON.decode(zh)
t = "*⤈︙ قائمه الزخرفه .\n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ \n*"
for k,v in pairs(zx.Get) do
t = t.."*"..k.."*⤈︙ `"..v.."` \n"
end
bot.sendText(msg.chat_id,msg.id,t..' *ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⤈︙ اضغط على الاسم ليتم نسخه .*',"md",true) 
end
if text == "زخرفة" or text == "زخرفه" then
if not redis:get(bot_id.."myzhrfa"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ الزخرفه معطله بواسطه المشرفين .","md",true)
end
redis:setex(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":settings:decor",300,true)  
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسل النص الان باللغه الانكليزيه او العربيه .*","md",true) 
end
if text and text:match("^احسب (.*)$") then
if not redis:get(bot_id.."calculate"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ حساب العمر معطل بواسطه المشرفين .","md",true)
end
local Textage = text:match("^احسب (.*)$")
u , res = https.request('https://black-source.xyz/BlackTeAM/Calculateage.php?age='..Textage)
JsonSInfo = JSON.decode(u)
InfoGet = JsonSInfo['result']['info']
bot.sendText(msg.chat_id,msg.id,InfoGet,"md", true)
end
if text == "الابراج" then
if not redis:get(bot_id.."brjj"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"⤈︙ الابراج معطله بواسطه المشرفين .","md",true)
end
yMarkup = bot.replyMarkup{
type = 'inline',data = {
{{text = "‹ برج الجوزاء ›",data=msg.sender_id.user_id.."Getprjالجوزاء"},{text ="‹ برج الثور ›",data=msg.sender_id.user_id.."Getprjالثور"},{text ="‹ برج الحمل ›",data=msg.sender_id.user_id.."Getprjالحمل"}},
{{text = "‹ برج العذراء ›",data=msg.sender_id.user_id.."Getprjالعذراء"},{text ="‹ برج الاسد ›",data=msg.sender_id.user_id.."Getprjالاسد"},{text ="‹ برج السرطان ›",data=msg.sender_id.user_id.."Getprjالسرطان"}},
{{text = "‹ برج القوس ›",data=msg.sender_id.user_id.."Getprjالقوس"},{text ="‹ برج العقرب ›",data=msg.sender_id.user_id.."Getprjالعقرب"},{text ="‹ برج الميزان ›",data=msg.sender_id.user_id.."Getprjالميزان"}},
{{text = "‹ برج الحوت ›",data=msg.sender_id.user_id.."Getprjالحوت"},{text ="‹ برج الدلو ›",data=msg.sender_id.user_id.."Getprjالدلو"},{text ="‹ برج الجدي ›",data=msg.sender_id.user_id.."Getprjالجدي"}},
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
bot.sendText(msg.chat_id,msg.id,"*⤈︙ قم بأختيار برجك الان .*","md", true, false, false, false, yMarkup)
end

if text == ("تفاعلي") and tonumber(msg.reply_to_message_id) == 0 then  
local nummsg = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":message") or 1
local edit = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Editmessage")or 0
local addmem = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Addedmem") or 0
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":game") or 0
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = '‹ الرسائل ›',data="iforme_"..msg.sender_id.user_id.."_1"},{text ="( "..nummsg.." )",data="iforme_"..msg.sender_id.user_id.."_1"}},
{{text = '‹ السحكات ›',data="iforme_"..msg.sender_id.user_id.."_2"},{text ="( "..edit.." )",data="iforme_"..msg.sender_id.user_id.."_2"}},
{{text = '‹ الجهات ›',data="iforme_"..msg.sender_id.user_id.."_3"},{text ="( "..addmem.." )",data="iforme_"..msg.sender_id.user_id.."_3"}},
{{text = '‹ النقاط ›',data="iforme_"..msg.sender_id.user_id.."_4"},{text ="( "..Num.." )",data="iforme_"..msg.sender_id.user_id.."_4"}},
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اهلا بك في قائمه التفاعل الخاصه بك .*","md", true, false, false, false, reply_markup)
return false
end
if text == 'اوامر المسح' then
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = '‹ مسح رسائلي ›',data="delforme_"..msg.sender_id.user_id.."_1"},{text ="‹ مسح سحكاتي ›",data="delforme_"..msg.sender_id.user_id.."_2"}},
{{text ="‹ مسح نقاطي ›",data="delforme_"..msg.sender_id.user_id.."_4"},{text = '‹ مسح جهاتي ›',data="delforme_"..msg.sender_id.user_id.."_3"}},
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اهلا بك في اوامر المسح .\n⤈︙ قم بأختيار ما تريد بالضغط اسفل .*","md", true, false, false, false, reply_markup)
end
if text and text:match('^اهداء @(%S+)$') then
local UserName = text:match('^اهداء @(%S+)$') 
mmsg = bot.getMessage(msg.chat_id,msg.reply_to_message_id)
if mmsg and mmsg.content then
if mmsg.content.luatele ~= "messageVoiceNote" and mmsg.content.luatele ~= "messageAudio" then
return bot.sendText(msg.chat_id,msg.id,'*⤈︙ عذرأ لا ادعم هذا النوع من الاهدائات*',"md",true)  
end
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
return bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ لا يوجد حساب بهذا المعرف*","md",true)   end
local UserInfo = bot.getUser(UserId_Info.id)
if UserInfo.first_name and UserInfo.first_name ~= "" then
local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '‹ رابط الاهداء ›', url ="https://t.me/c/"..string.gsub(msg.chat_id,"-100",'').."/"..(msg.reply_to_message_id/2097152/0.5)}}}}
local UserInfom = bot.getUser(msg.sender_id.user_id)
if UserInfom.username and UserInfom.username ~= "" then
Us = '@['..UserInfom.username..']' 
else 
Us = 'لا يوجد ' 
end
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
return bot.sendText(msg.chat_id,msg.reply_to_message_id,'*⤈︙ هذا الاهداء لـك ( @'..UserInfo.username..' ) عمري فقط ♥️\n⤈︙ اضغط على رابط الهداء للستماع الى البصمة  ↓\n⤈︙ صاحب الاهداء هـوه »* '..Us..'',"md",true, false, false, false, reply_markup)  
end
end
end

if text == "شنو رئيك بهذا" or text == "شنو رئيك بهذ" then
local texting = {"ادب سسز يباوع علي بنات ??🥺"," مو خوش ولد 😶","زاحف وما احبه 😾??"}
bot.sendText(msg.chat_id,msg.id,"*"..texting[math.random(#texting)].."*","md", true)
end
if text == "شنو رئيك بهاي" or text == "شنو رئيك بهايي" then
local texting = {"دور حلوين 🤕😹","جكمه وصخه عوفها ☹️😾","حقيره ومنتكبره 😶😂"}
bot.sendText(msg.chat_id,msg.id,"*"..texting[math.random(#texting)].."*","md", true)
end
if text == "هينه" or text == "رزله" then
heen = {
" حبيبي علاج الجاهل التجاهل ."
," مالي خلك زبايل التلي . "
," كرامتك رفعهت بزبل פَــبي ."
," مو صوجك صوج الكواد الزمك جهاز ."
," لفارغ استجن . "
," لتتلزك بتاجراسك ."
," ملطلط دي ."
};
sendheen = heen[math.random(#heen)]
if tonumber(msg.reply_to_message_id) == 0 then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ يجب عمل رد على رساله شخص .*","md", true)
return false
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if developer(Remsg) then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ لا خاف عيب هذا مطوري .*","md", true)
return false
end
bot.sendText(msg.chat_id,msg.reply_to_message_id,"*"..sendheen.."*","md", true)
end
if text == "مصه" or text == "بوسه" then
local texting = {"مووووووووواححح????","مممممححه ??😥","خدك/ج نضيف 😂","البوسه بالف حمبي ??💋","ممحمحمحمحح 😰😖","كل شويه ابوسك كافي 😏","ماابوسه والله هذا زاحف🦎","محح هاي لحاته صاكه??"}
if tonumber(msg.reply_to_message_id) == 0 then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ يجب عمل رد على رساله شخص .*","md", true)
return false
end
bot.sendText(msg.chat_id,msg.reply_to_message_id,"*"..texting[math.random(#texting)].."*","md", true)
end
if text == "تاكات" then
if Administrator(msg) then
local arr = {
"@ل15 كله اكثر انمي تتابعه؟",
"@ل13 كله اكثر فلم تحبه ؟",
"@ل10 كله لعبه تحبها؟",
"@ل17 كله اغنيـۿ تحبها ؟",
"@ل4 كله اعترفلي ؟",
"@ل7 كله اعترف بموقف محرج ؟",
"@ل6 كله اعترف بسر ؟",
"@ل4 كله انته كي  ؟",
"@ل8 كله اريد اخطفك؟",
"@ل9 كله انطيني بوسه ؟",
"@ل10 كله انطيني حضن ؟",
"@ل9 كله انطيني رقمك ؟",
"@ل2 كله انطيني سنابك؟",
"@ل9 كله انطيني انستكرامك ؟",
"@ل12 كله اريد هديه؟",
"@ل11 كله نلعب  ؟",
"@ل6 كله اقرالي شعر؟",
"@ل7 كله غنيلي واغنيلك ؟",
"@ل13 كله ليش انته حلو؟",
"@ل3 كله انت كرنج ؟",
"@ل1 كله نتهامس؟",
"@ل6 كله اكرهك ؟",
"@ل8 كله احبك؟",
"@ل5 كله نتعرف ؟",
"@ل2 كله نتصاحب وتحبني؟",
"@ل3 كله انته حلو ؟",
"@ل2 كله احبك وتحبني؟",
"@ل15 كله اكثر اكله تحبها؟",
"@ل13 كله اكثر مشروب تحبه ؟",
"@ل10 كله اكثر نادي تحبه؟",
"@ل17 كله اكثر ممثل تحبه ؟",
"@ل4 كله صوره لخاصك ؟",
"@ل7 كله صوره لبرامجك ؟",
"@ل6 كله  صوره لحيوانك ؟",
"@ل4 كله صوره لقنواتك ؟",
"@ل8 كله عمرك خنت شخص؟",
"@ل9 كله كم مره حبيت  ؟",
"@ل10 كله اعترف لشخص؟",
"@ل9 كله اتحب الالعاب ؟",
"@ل2 كله تحب الشعر؟",
"@ل9 كله تحب الاغاني ؟",
"@ل12 كله اريد ايفون ؟",
"@ل11 كله تحب الفراوله  ؟",
"@ل6 كله تحب المونستر؟",
"@ل7 كله تحب الاكل؟ ؟",
"@ل13 كله تحب الككو ؟",
"@ل3 كله تحب البيض ؟",
"@ل1 كله بلوك منحياتي ؟",
"@ل6 كله كرشت عليك ؟",
"@ل8 كله نصير بيست ؟",
"@ل5 كله انتت قمر ؟",
"@ل2 كله نتزوج؟",
"@ل3 كله انته مرتبط ؟",
"@ل2 كله نطمس؟",
"@ل8 كله تريد شكليطه؟",
"@ل9 كله تحب  السمك  ؟",
"@ل10 كله تحب الكلاب ؟",
"@ل9 كله تحب القطط ؟",
"@ل2 كله تحب الريمكسات",
"@ل9 كله تحب الراب ؟",
"@ل12 كله تحب بنترست ؟",
"@ل11 كله تحب التيك توك  ؟",
"@ل6 كله اكثر متحركه تحبها",
"@ل7 كله اكثر فويس تحبه ؟",
"@ل13 كله اكثر ستيكر تحبه؟",
"@ل3 كله ماذا لو عاد متعتذرا ؟",
"@ل1 كله خذني بحضنك ؟",
"@ل6 كله اثكل شوي ؟",
"@ل8 كله اهديني اغنيه ؟",
"@ل5 كله حبيتك ؟",
"@ل2 كله انت لطيف ؟",
"@ل3 كله انت عصبي  ؟",
"@ل2 كله اكثر ايموجي تحبه؟"
}
bot.sendText(msg.chat_id,0,arr[math.random(#arr)],"md", true)
redis:setex(bot_id..":PinMsegees:"..msg.chat_id,60,text)
end
end

if text == "كت" or text == "تويت" or text == "كت تويت" then
if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," ⤈︙ اوامر التسليه معطله بواسطه المشرفين .","md",true)
end
local texting = {"اخر افلام شاهدتها", 
"آخر مرة زرت مدينة الملاهي؟",
"آخر مرة أكلت أكلتك المفضّلة؟",
"الوضع الحالي؟\n‏1. سهران\n‏2. ضايج\n‏3. أتأمل",
"آخر شيء ضاع منك؟",
"كلمة أخيرة لشاغل البال؟",
"طريقتك المعتادة في التخلّص من الطاقة السلبية؟",
"شهر من أشهر العام له ذكرى جميلة معك؟",
"كلمة غريبة من لهجتك ومعناها؟🤓",
"‏- شيء سمعته عالق في ذهنك هاليومين؟",
"متى تكره الشخص الذي أمامك حتى لو كنت مِن أشد معجبينه؟",
"‏- أبرز صفة حسنة في صديقك المقرب؟",
"هل تشعر أن هنالك مَن يُحبك؟",
"اذا اكتشفت أن أعز أصدقائك يضمر لك السوء، موقفك الصريح؟",
"أجمل شيء حصل معك خلال هاليوم؟",
"صِف شعورك وأنت تُحب شخص يُحب غيرك؟👀💔",
"كلمة لشخص غالي اشتقت إليه؟💕",
"آخر خبر سعيد، متى وصلك؟",
"أنا آسف على ....؟",
"أوصف نفسك بكلمة؟",
"‏- ماذا ستختار من الكلمات لتعبر لنا عن حياتك التي عشتها الى الآن؟💭",
"كيف تتعامل مع الشخص المُتطفل ( الفضولي , ؟",
"أصعب صفة قد تتواجد في المرأة.؟",
"مع أو ضد لو كان خيراً لبقئ.؟",
"نصيحة لكل شخص يذكر أحد بغيابة بالسوء.؟",
"كل شيء يهون الا ؟",
"هل أنت من النوع الذي يواجه المشاكل أو من النوع الذي يهرب ؟",
"كلمه لشخص خانك!؟.",
"تحب تحتفظ بالذكريات ؟",
"شاركنا أقوى بيت شِعر من تأليفك؟",
"‏اسرع شيء يحسّن من مزاجك؟",
"كلمتك التسليكيه ؟",
"كم ساعات نومك؟.",
"عندك فوبيا او خوف شديد من شيء معين ؟",
"موهبة تفوز بمدح الناس لك.؟",
"قدوتك من الأجيال السابقة؟",
"شخص تتمنئ له الموت؟.",
"عادةً تُحب النقاش الطويل أم تحب الاختصار؟",
"تاك لشخص نيته زباله🌚؟",
"صوتك حلو ؟ .",
"كلمتريكس تكررها دايم؟!",
"افضل روايه قريتيها؟.",
"متى حدث التغيير الكبير والملحوظ في شخصيتك؟",
"أكثر اكله تحبها؟.",
"‏كلما ازدادت ثقافة المرء ازداد بؤسه",
"تتفق.؟",
"اغبى كذبه صدقتها بطفولتك؟.",
"كم المده الي تخليك توقع بحب الشخص؟.",
"تسامح شخص وجع قلبك ؟.",
"ردة فعلك لما تنظلم من شخص ؟",
"شيء يعدل نفسيتك بثواني.؟",
"‏تتوقع الإنسان يحس بقرب موته؟",
"وقت حزنك تلجأ لمن يخفف عنك.؟",
"‏أكثر شيء شخصي ضاع منك؟",
"تزعلك الدنيا ويرضيك ؟",
"ما الذي يشغل بالك في الفترة الحالية؟",
"نهارك يصير أجمل بوجود ..؟",
"حسيت انك ظلمت شخص.؟",
"صفة يطلقها عليك من حولك بكثرة؟",
"‏يوم لا يمكنك نسيانه؟",
"اخر كلمة قالها لك حبيبك؟.",
"من الشخص الاقرب لقلبك؟.",
"كم المده الي تخليك توقع بحب الشخص؟.",
"ماهي الهدية التي تتمنى أن تنتظرك يومًا أمام باب منزلك؟",
"‏اسم او تاك لشخص لا ترتاح في يومك إلا إذا حاجيته؟",
"صديق أمك ولا أبوك. ؟",
"لماذا الأشياء التي نريدها بشغف تأتي متأخرة؟",
"‏تقبل بالعودة لشخص كسر قلبك مرتريكس؟",
"افضل هديه ممكن تناسبك؟",
"كلمة غريبة ومعناها؟",
"اذا اشتقت تكابر ولا تبادر ؟.",
"بامكانك تنزع شعور من قلبك للابد ، ايش هو؟.",
"لو بتغير اسمك ايش بيكون الجديد ؟",
"‏شخصية لا تستطيع تقبلها؟",
"ما هي طريقتك في الحصول على الراحة النفسية؟",
"‏ايموجي يوصف مزاجك حاليًا بدقة؟",
"تاريخ ميلادك؟",
"كيف تحد الدولة من الفقر المُتزايد.؟",
"‏شي مستحيل يتغير فيك؟",
"لو اخذوك لمستشفى المخابيل كيف تثبت انت صاحي؟",
"إيموجي يعبّر عن مزاجك الحالي؟",
"وقت حزنك تلجأ لمن يخفف عنك.؟",
"اعترف اللاعبين حاجه ؟",
"شاركني آخر صورة جميلة من كاميرا هاتفك.؟",
"متصالح مع نفسك؟.",
"لو عندك امنيه وبتحقق وش هي؟.",
"هل انت شخص مادي.؟",
"أخر اتصال جاك من مين ؟",
"تاك لصديقك المُقرب؟.",
"تحب العلاقات العاطفيه ولا الصداقه؟.",
"العين الي تستصغرك........؟",
"تجامل الناس ولا اللي بقلبك على لسانك؟",
"وقت حزنك تلجأ لمن يخفف عنك.؟",
"صفه تتمناها بشريك حياتك؟.",
"من اصدق في الحب الولد ولا البنت؟.",
"يرد عليك متأخر على رسالة مهمة وبكل برود، موقفك؟",
"كلمة لشخص بعيد؟",
"رحتي لعرس وأكتشفتي العريس حبيبك شنو ردة فعلك.؟",
"تسامح شخص وجع قلبك ؟.",
"احقر موقف صار لك؟.",
"ماذا لو كانت مشاعر البشر مرئية ؟",
"وين نلقى السعاده برايك؟",
"قد تخيلت شي في بالك وصار ؟",
"صفة يطلقها عليك الشخص المفضّل؟",
"اخر خيانه؟.",
"تحب تحتفظ بالذكريات ؟",
"لو بتغير اسمك ايش بيكون الجديد ؟",
"الاعتذار أخلاق ولا ضعف.؟",
"هل أنت من النوع الذي يواجه المشاكل أو من النوع الذي يهرب ؟",
"‏ تكره أحد من قلبك ؟",
"تاك لشخص وكوله اعترف لك؟",
"مع أو ضد لو كان خيراً لبقئ.؟",
"‏هل لديك شخص لا تخفي عنه شيئًا؟",
"اغنيه تأثر بيك؟",
"المطوعة والعاقلة من شلتك.؟",
"مواصفات امير/ة احلامك؟.",
"‏كلمة لصديقك البعيد؟",
"تتابع انمي؟ إذا نعم ما أفضل انمي شاهدته؟",
"قرارتك راضي عنها ام لا ؟",
"تسامح شخص سبب في بكائك.؟",
"لو حصل واشتريت جزيرة، ماذا ستختار اسمًا لها.؟",
"اغنيتك المفضلة؟.",
"شاركنا اقوئ نكتة عندك.؟",
"ماذا لو عاد مُشتاقاً.؟",
"مسلسل كرتوني له ذكريات جميلة عندك؟",
"أخر اتصال جاك من مين ؟",
"حيوانك المفضل؟",
"اول ولد لك شنو رح تسميه ؟",
"سبب الرحيل.؟",
"قولها بلهجتك « لا أملك المال ».؟",
"نهارك يصير أجمل بوجود ..؟",
"‏لو خيروك، الزواج بمن تُحب او تاخذ مليون دينار؟",
"تاك لشخص سوالفه حلوه ؟",
"تصرف لا يُمكن أن تتحمله.؟",
"ماهي الاطباع فيك التي تحاول اخفائها عن الناس؟.",
"شيء عندك اهم من الناس؟",
"قد تخيلت شي في بالك وصار ؟",
"تمحي العشرة الطيبة عشان موقف ماعجبك أو سوء فهم.؟",
"جربت شعور احد يحبك بس انت متكدر تحبه؟",
"بنفسك تبوس شخص بهاي الحظه؟",
"إذا كانت الصراحة ستبعد عنك من تحب هل تمتلك الشجاعة للمصارحة ام لا .؟",
"أكمل الدعاء بما شئت ‏اللهم أرزقني ..؟",
"الصق اخر شيء نسخته .؟",
"‏تفضل جولة في الغابة أم جولة بحرية؟",
"‏تاك لشخص لديك لا تخفي عنه شي؟",
"كلمة غريبة ومعناها؟",
"‏اوقات لا تحب ان يكلمك فيها احد؟",
"تملك وسواس من شيء معين ؟",
"اشمر مقطع من اغنيه متطلع منراسك؟",
"هل تتأثرين بالكلام الرومانسي من الشباب؟",
"ما اول شيء يلفت انتباهك في الرجل؟",
"ماذا تفعلين اذا تعرضتِ للتحرش من قبل شخص ما..؟",
"اذا كنت شخصاً غني هل توافق على الزواج من فتاة فقيرة..؟",
"ما هو أكثر شئ لا تستطيع تحمله..؟",
"ما هي نقاط الضعف في شخصيتك..؟",
"هل توافق أن زوجتك تدفع الحساب في إحدي المطاعم وأنت موجود؟",
"ماذا تفعل لو أكتشفت ان زوجتك على علاقة بصديقك؟",
"ما هي أكثر صفة تكرهها في زوجتك..؟",
"اذا كان لديك فرصة للخروج مع من سوف تخرج ربعك او زوجتك..؟",
"ماذا تفعل عندما تري دموع زوجتك..؟",
"إلى أي الرجال تُريدين أن يكون انتماؤك؟",
"كم مرة خُدعت في أشخاصٍ، وثقتِ فيهم ثقةً عمياء؟",
"هل ما زال أصدقاء الطفولة أصدقاءً لك حتى الآن؟",
"هل ترغبين في أن يكون خطيبك وسيمًا؟",
"كم مرةٍ فعلت شيئًا لا ترغبين في الإفصاح عنه؟",
"هل استطعت أن تُحققي آمالك العلمية والعاطفية؟",
"أكثر شئ ندمت على فعله..؟",
"هل تشعرين أنك فتاة محظوظة..؟",
"هل علاقة الحب التي كانت في صغرك، مازالت مستمرة؟",
"ما هو أكثر شئ يفرحك في هذه الحياة..؟",
"كم مرة أردت شراء ملابس لأنها جميلة ولكنها لا تناسبك..؟",
"كم عدد المرات التي قمت فيها بإستبدال شئ اشتريته ولم يعجبك بعد ذلك.؟",
"كم مرة قمت بكسر الرجيم من أجل تناول طعامك المفضل..؟",
"هل تعرضت للظلم يوماً ما وعلى يد من..؟",
"هل كذبت على والديك من قبل..؟",
"هل خرجتي مع شخص تعرفتي عليه من خلال التليكرام من قبل..؟",
"هل لو تقدم شخص لاختك من أجل خطبتها وقامت برفضه تقبلين به..؟",
"لمن تقولين لا أستطيع العيش بدونك..؟",
"كم عدد المرات التي تعرضتِ فيها إلى أزمة نفسية وأردتِ الصراخ بأعلى صوتك..؟",
"ماذا تقول للبحر؟",
"أصعب صفة قد تتواجد في رجل؟",
"ما أجمل الحياة بدون ...؟",
"لماذا لم تتم خطبتك حتى الآن..؟",
"نسبة رضاك عن الأشخاص من حولك هالفترة ؟",
"ما السيء في هذه الحياة ؟",
"الفلوس او الحب ؟",
"أجمل شيء حصل معك خلال هذا الاسبوع ؟",
"سؤال ينرفزك ؟",
"كم في حسابك البنكي ؟",
"شي عندك اهم من الناس ؟",
"اول ولد او بنت الك شنو تسمي ؟",
"تفضّل النقاش الطويل او تحب الاختصار ؟",
"عادي تتزوج او تتزوجين من خارج العشيره ؟",
"كم مره حبيت ؟",
"تبادل الكراهية بالكراهية؟ ولا تحرجه بالطيب ؟",
"قلبي على قلبك مهما صار لمنو تكولها ؟",
"نسبة النعاس عندك حاليًا ؟",
"نسبه الندم عندك للي وثقت بيهم ؟",
"اول شخص تعرفت عليه بالتليكرام بعده موجود ؟",
"اذا فديوم شخص ضلمك شنو موقفك ؟",
"افضل عمر للزواج برئيك ؟",
"انت من النوع الي دائما ينغدر من اقرب الناس اله ؟",
"ماهو حيوانك المفضل ؟",
"تاريخ ميلادك ؟",
"لونك المفضل ؟",
"انت من النوع العاطفي والي ميكدر يكتم البداخله ؟",
"اذا فديوم شخص خانك ويريد يرجعلك تقبل ؟",
"شي بالحياه مخليك عايش لحد الان ؟",
"تحب النوم لو الشغل ؟",
"افضل مكان رحت عليه ؟",
"اختصر الماضي بكلمه وحده ؟",
"هل سبق وكنت مصر على أمر ما ومن ثم اكتشفت أنك كنت على خطأ ؟",
"اكثر كلمة ترفع ضغطك ؟",
"مع او ضد سب البنت للدفاع عن نفسها ؟",
"يهمك ظن الناس بيك لو لا؟",
"عبّر عن مودك بصوره ؟",
"اغلب وقتك ضايع في ؟",
"يوم متكدر تنساه ؟",
"تحس انك محظوظ بالاشخاص الي حولك ؟",
"تستغل وقت فراغك بشنو ؟",
"مع او ضد مقولة محد يدوم ل احد ؟",
"لو اخذوك مستشفى المجانين كيف تثبت لهم انك صاحي ؟",
"مغني تلاحظ أن صوته يعجب الجميع إلا أنت ؟",
"اخر خيانه ؟",
"تصرف ماتتحمله ؟",
"هل يمكنك الكذب والاستمرار بارتكاب الأخطاء كمحاولة منك لعدم الكشف أنك مخطئ ؟",
"الصق اخر شي نسخته ؟",
"عمرك انتقمت من أحد ؟",
"هل وصلك رسالة غير متوقعة من شخص وأثرت فيك ؟",
"‏-لو امتلكت العصا السحرية ليوم واحد ماذا ستفعل ؟",
"جابو طاري شخص تكره عندك تشاركهم ولا تمنعهم ؟",
"أمنية كنت تتمناها وحققتها ؟",
"هل التعود على شخص والتحدث معه بشكل يومي يعتبر نوع من أنواع الحب ؟",
"نسبة جمال صوتك ؟",
"صفة يطلقها عليك الشخص المفضل ؟",
"شنو هدفك بالمستقبل القريب ؟",
"تحب القرائه ؟",
"كليه تتمنى تنقبل بيها ؟",
"أطول مدة قضيتها بعيد عن أهلك ؟",
"لو يجي عيد ميلادك تتوقع يجيك هدية؟",
"يبان عليك الحزن من  صوتك - ملامحك",
"وين تشوف نفسك بعد سنتريكس؟",
"وش يقولون لك لما تغني ؟",
"عندك حس فكاهي ولا نفسية؟",
"كيف تتصرف مع الشخص الفضولي ؟",
"كيف هي أحوال قلبك؟",
"حاجة تشوف نفسك مبدع فيها ؟",
"متى حبيت؟",
"شيء كل م تذكرته تبتسم ...",
"العلاقه السريه دايماً تكون حلوه؟",
"صوت مغني م تحبه",
"لو يجي عيد ميلادك تتوقع يجيك هدية؟",
"اذا احد سألك عن شيء م تعرفه تقول م اعرف ولا تتفلسف ؟",
"مع او ضد : النوم افضل حل لـ مشاكل الحياة؟",
"مساحة فارغة (.............) اكتب اي شيء تبين",
"اغرب اسم مر عليك ؟",
"عمرك كلمت فويس احد غير جنسك؟",
"اذا غلطت وعرفت انك غلطان تحب تعترف ولا تجحد؟",
"لو عندك فلوس وش السيارة اللي بتشتريها؟",
"وش اغبى شيء سويته ؟",
"شيء من صغرك ماتغير فيك؟",
"وش نوع الأفلام اللي تحب تتابعه؟",
"وش نوع الأفلام اللي تحب تتابعه؟",
"تجامل احد على حساب مصلحتك ؟",
"تتقبل النصيحة من اي شخص؟",
"كلمه ماسكه معك الفترة هذي ؟",
"متى لازم تقول لا ؟",
"اكثر شيء تحس انه مات ف مجتمعنا؟",
"تؤمن ان في حُب من أول نظرة ولا لا ؟.",
"تؤمن ان في حُب من أول نظرة ولا لا ؟.",
"هل تعتقد أن هنالك من يراقبك بشغف؟",
"اشياء اذا سويتها لشخص تدل على انك تحبه كثير ؟",
"اشياء صعب تتقبلها بسرعه ؟",
"اقتباس لطيف؟",
"أكثر جملة أثرت بك في حياتك؟",
"عندك فوبيا من شيء ؟.",
"اكثر لونين تحبهم مع بعض؟",
"أجمل بيت شعر سمعته ...",
"سبق وراودك شعور أنك لم تعد تعرف نفسك؟",
"تتوقع فيه احد حاقد عليك ويكرهك ؟",
"أجمل سنة ميلادية مرت عليك ؟",
"لو فزعت/ي لصديق/ه وقالك مالك دخل وش بتسوي/ين؟",
"وش تحس انك تحتاج الفترة هاذي ؟",
"يومك ضاع على؟",
"@منشن .. شخص تخاف منه اذا عصب ...",
"فيلم عالق في ذهنك لا تنساه مِن روعته؟",
"تختار أن تكون غبي أو قبيح؟",
"الفلوس او الحب ؟",
"أجمل بلد في قارة آسيا بنظرك؟",
"ما الذي يشغل بالك في الفترة الحالية؟",
"احقر الناس هو من ...",
"وين نلقى السعاده برايك؟",
"اشياء تفتخر انك م سويتها ؟",
"تزعلك الدنيا ويرضيك ؟",
"وش الحب بنظرك؟",
"افضل هديه ممكن تناسبك؟",
"كم في حسابك البنكي ؟",
"كلمة لشخص أسعدك رغم حزنك في يومٍ من الأيام ؟",
"عمرك انتقمت من أحد ؟!",
"ما السيء في هذه الحياة ؟",
"غنية عندك معاها ذكريات🎵🎻",
"أفضل صفة تحبه بنفسك؟",
"اكثر وقت تحب تنام فيه ...",
"أطول مدة نمت فيها كم ساعة؟",
"أصعب قرار ممكن تتخذه ؟",
"أفضل صفة تحبه بنفسك؟",
"اكثر وقت تحب تنام فيه ...",
"أنت محبوب بين الناس؟ ولاكريه؟",
"إحساسك في هاللحظة؟",
"اخر شيء اكلته ؟",
"تشوف الغيره انانيه او حب؟",
"اذكر موقف ماتنساه بعمرك؟",
"اكثر مشاكلك بسبب ؟",
"اول ماتصحى من النوم مين تكلمه؟",
"آخر مرة ضحكت من كل قلبك؟",
"لو الجنسية حسب ملامحك وش بتكون جنسيتك؟",
"اكثر شيء يرفع ضغطك",
"اذكر موقف ماتنساه بعمرك؟",
"لو قالوا لك  تناول صنف واحد فقط من الطعام لمدة شهر .",
"كيف تشوف الجيل ذا؟",
"ردة فعلك لو مزح معك شخص م تعرفه ؟",
"ما معنَى الحُرية في قامُوسك ؟",   
"تحب النقاش الطويل ولا تختصر الكلام ؟",   
"تكلم عن شخص تحبه بدون ماتحط اسمه",   
"كم تاخذ عشان تثق بأحد؟ و تثق بكثرة المواقف او السنين؟",
"من اللي يجب ان يبادر بالحب اول البنت او الولد؟",   
"‏- شاركنا مقولة أو بيت شعبي يُعجبك؟",   
"‏- كم تحتاج من وقت لتثق بشخص؟",   
"‏- شعورك الحالي في جملة؟",   
"‏- تصوّرك لشكل 2021 وأحداثها؟",   
"‏- أكلة يُحبها جميع أفراد المنزل ما عدا انت؟",   
"‏- تحافظ على الرياضة اليومية أم الكسل يسيطر عليك؟",   
"‏- مبدأ في الحياة تعتمد عليه دائما؟",   
"‏- نسبة رضاك عن تصرفات مَن تعرفهم في الفترة الأخيرة؟",   
"‏- كتاب تقرأه هذه الأيام؟",   
"‏- نسبة رضاك عن تصرفات مَن تعرفهم في الفترة الأخيرة؟",   
"‏- اكتشفت أن الشخص المقرّب أخبر أصدقائك بِسر مهم عنك، ردة فعلك؟👀",   
"‏- شخص يقول لك تصرفاتك لا تعجبني غيّرها، لكن أنت ترى أن تصرفاتك عادية، ماذا تفعل؟",   
"حالياً الاغنية المترأسة قلبك هي؟",   
"‏- أقوى عقاب بتسويه لشخص مقرّب اتجاهك؟",   
"‏- هل تُظهِر حزنك واستيائك من شخص للآخرين أم تفضّل مواجهته في وقتٍ لاحق؟",   
"‏- أكلة يُحبها جميع أفراد المنزل ما عدا انت؟",   
" مين افخم بوت في التيلجرام?",   
" ‏- اكتشفت أن الشخص الذي أحببته يتسلى بك لملئ فراغه، موقفك؟",   
"‏- تاريخ جميل لا تنساه؟",   
"لو اتيحت لك فرصة لمسح ذكرى من ذاكرتك ماهي هذه الذكرى؟",  
" -  من علامات الجمال وتعجبك بقوة؟",   
" -  يومي ضاع على ....؟",   
" -  أكثر شيء تقدِّره في الصـداقات؟",   
" -  صفة تُجمّل الشخـص برأيك؟",   
" -  كلمة غريبة من لهجتك ومعناها؟",   
" -  شيء تتميز فيه عن الآخرين؟",   
" -  ‏وش أول جهاز جوال اشتريته ؟؟",   
" -  ‏وش اول برنامج تفتحه لما تصحى من النوم وتمسك جوالك ؟",   
" -  ‏كلما ازدادت ثقافة المرء ازداد بؤسه, تتفق؟",   
" -  ‏برايك من أهم مخترع المكيف ولا مخترع النت ؟",   
" -  ‏وش رايك بالزواج المبكر ؟",   
" -  ‏وش أكثر صفه ماتحبها بشخصيتك  ؟",   
" -  ‏من اللي يجب ان يبادر بالحب اول البنت لو الولد؟",   
" -  ‏هل تعايشت مع الوضع الى الان او لا؟",   
" -  ‏كيفك مع العناد؟",   
" -  ‏هل ممكن الكره يتبدل؟",   
" -  ‏بشنو راح ترد اذا شخص استفزك؟",   
" -  ‏كم زدت او نقصت وزن في الفتره ذي؟",   
" -  ‏تشوف في فرق بين الجرأة والوقاحة؟",   
" -  ‏اكثر مدة م نمت فيها؟",   
" -  ‏اغلب قراراتك الصح تكون من قلبك وله عقلك؟",   
" -  ‏كم تريد يكون طول شريكك؟",   
" -  ‏لو فونك بيد احد اكثر برنامج م تبيه يدخله هو؟",   
" -  ‏اعظم نعمة من نعم الله عندك؟.",   
" -  ‏اغلب فلوسك تروح على وش؟",   
" -  ‏رايك بالناس اللي تحكم ع الشخص من قبيلته؟.",   
" -  ‏اكثر اسم تحب ينادوك فيه؟",   
" -  كم من مية تحب تشوف مباريات؟",   
" -  ‏اكثر شي مع اهل امك وله ابوك؟",   
" -  ‏صراحةً شكل الشخص يهم اذا انت بتحب شخص؟",   
" -  ‏فراق الصديق ام فراق الحبيب ايهم اسوء؟",   
" -  مين أعظم وأفخم بوت في التيلي؟",
" -  كم لغة تتقن؟",
" -  وش اجمل لغة برأيك؟", 
" -  تحب الكيبوب؟",
" -  فالتواصل مع الناس تفضل الدردشه كتابياً ولا المكالمات الصوتيه؟", 
" -  في أي سنة بديت تستخدم تطبيقات التواصل الإجتماعي؟",
" -  شاركنا أغنية غريبة تسمعها دايم؟",
" -  عن ماذا تبحث؟",
" -  تحبني ولا تحب الدراهم؟", 
" -  انا أحبك, وانت؟", 
" -  روحك تنتمي لمكان غير المكان اللي انت عايش فيه؟",
" -  كيف تتصرف لو تغيّر عليك أقرب شخص؟",
" - ‏أغبى نصيحة وصلتك؟",
" - هل اقتربت من تحقيق أحد أهدافك؟",
" - رأيك بمن يستمر في علاقة حب مع شخص وهو يعلم أنه على علاقة حب مع غيره؟",
"‏ - شخصية تاريخية تُحبها؟",
" - ‏كم ساعة نمت؟",
" - أكثر شخصية ممكن تستفزك؟",
" - ‏كلمة لمتابعينك؟",
"‏ - أجمل شعــور؟",
" - أسوأ شعور؟",
" - أقبح العادات المجتمعية في بلدك؟",
" - أحب مُدن بلادك إلى قلبك؟",
"‏ - أصعب أنواع الانتظار؟",
" - ‏ ماذا لو لم يتم اختراع الانترنت؟",
" - هل تعتقد أن امتلاكك لأكثر من صديق أفضل من امتلاكك لصديق واحد؟",
" - ‏ردة فعلك على شخص يقول لك: ما حد درى عنك؟",
" - كتاب تقرأه هذه الأيام؟",
" - ‏هل صحيح الشوق ياخذ من العافية ؟",
" - ‏لماذا الانسان يحب التغيير ؟ حتى وان كان سعيدا !",
"‏ - الاحباط متى ينال منك ؟",
" - ‏بعد مرور اكثر من عام هل مازال هناك من يعتقد ان كورونا كذبة  ؟",
" - هل  تشمت بعدوك وتفرح لضرره مهما كان الضرر قاسيا  ؟",
" - ‏ان كانت الصراحة ستبعد عنك من تحب هل تمتلك الشجاعة للمصارحة  ام لا ؟",
" - ‏ماهو حلك اذا اصابك الارق ؟",
" - ‏ماهو الامر  الذي لايمكن ان تسمح به ؟",
"‏ - هل تلتزم بمبادئك وان كان ثمنها غاليا ؟",
" - ‏ماهو اولى اولوياتك في الحياة ؟",
" - لو خيرت بين ان تعيش وحيدا برفاه  او بين الاحباب بشقاء ماذا ستختار ؟",
" - هل تلجأ الى شخص ينتظر سقوطك وهو الوحيد الذي بامكانه مساعدتك ؟",
" - ‏اكثر شيء تحب امتلاكه ؟",
" - معنى الراحة بالنسبة لك ؟",
" - عرف نفسك بكلمة ؟",
"‏ - لماذا لا ننتبه إلا حينما تسقُط الأشياء ؟",
" - ‏هل شعرت يومًا أنَّك تحتاج لطرح سؤال ما، لكنَّك تعرف في قلبك أنَّك لن تكون قادرًا على التعامل مع الإجابة؟",
" - ‏هل تبحث عن الحقيقة وهناك احتمال بانها ستكون قاسية عليك ؟",
" - ‏هل ظننت أن الأمر الذي أجلتهُ مرارًا لن تواجهه لاحقًا ؟",
" - قهوتك المفضلة وفي اي وقت تفضلها ؟",
" - ‏تطبيق مستحيل تمسحه؟",
" - ‏تسلك كثير ولا صريح؟",
" - ‏كلمة دايم تقولها؟",
" - كيف تعرف ان هالشخص يحبك ؟",
" - ‏ايش الشي الي يغير جوك ويخليك سعيد؟",
"‏ - تقدر تتقبل رأي الكل حتى لو كان غلط؟",
" - أكثر شيء تحبه في نفسك؟",
" - يا ليت كل الحياة بدايات.. مع أو ضد؟",
" - ما هي العناصر التي تؤمن النجاح في الحياة بنظرك؟",
" - هل تعاتِب من يُخطئ بحقك أم تتبع مبدأ التجاهل؟",
" - كم لعبة في هاتفك؟",
" - أجمل مرحلة دراسية مرت بحياتك؟",
" - ما هو مفتاح القلوب؟ الكلمة الطيبة أم الجمال؟",
" - الخصام لا يعني الكُره.. تتفقون؟",
" - مِن مواصفات الرجل المثالي؟",
" - ما رأيك بمقولة: الناس معك على قد ما معك؟",
" - كلمة لمن يتصفح حسابك بشكل يومي؟",
" - خُرافة كنت تصدقها في طفولتك؟",
" - ‏ إنما الناس لطفاء بحجم المصلحة.. مع أو ضد؟",
" - ‏ حلم تفكر به دائمًا لكن تعلم دائما أن نسبة تحقيقه ضئيلة؟💔",
" - لو كان الأمر بيدك، ما أول قاعدة ستقوم بتطبيقها؟",
" - يزيد احترامي لك، لمّا ....؟",
" - هل سبق وأُعجبت بشخص من أسلوبه؟",
" - كل شيء يتعوّض إلا .. ؟",
" - ما النشاط الذي لن تمل يوماً من فعله؟",
" - ‏ لَون تتفاءل فيه؟",
" - تعتبر نفسك من النوع الصريح؟ أم تجامل بين الحين والآخر؟",
" - أكثر سؤال يثير غضبك؟",
" - أكثر شيء يضيع منك؟😅",
" - شيء سلبي في شخصيتك وتود التخلص منه؟",
" - ‏- هل تتذكر نوع أول هاتف محمول حصلت عليه؟",
" - اكثر مكان تحب تروح له ف الويكند ؟",
" - كم وجبه تاكل ف اليوم ؟",
" - منشن شخص فاهمك ف كل شيء ؟",
" - من علامات روقانك ؟",
" - تشوف انو التواصل بشكل يومي من اساسيات الحب ؟",
" - كيف تتصرف مع شخص تكلمه في سالفه مهمه ويصرفك ؟",
" - هل برأيك أن عبارة محد لأحد صحيحه ام تعقتد عكس ذلك؟",
" - شي مشتهر فيه عند عايلتك؟",
" - اكثر مكان تكتب فيه  وتفضفض ؟",
" - وقفة إحترام للي إخترع ؟",
" - أقدم شيء محتفظ فيه من صغرك؟",
" - أمنيه تمنيتها وتحققت؟",
" - شي ما تستغني عنه ف الطلعات ؟",
" - لغة تود تعلمها ؟",
" - اكثر شي مضيع عليه فلوسك ؟",
" - هل انت من الناس اللي تخطط وتفكر كثير قبل ماتتكلم؟",
" - اهم نصيحه للنجاح بشكل عام ؟",
" - كيف تتعاملون مع شخص كنت طيب معه و تمادى صار يحس كل شئ منك مفروض و واجب بالغصب؟!",
" - شي نفسك تجربه ؟",
" - أشياء توترك ؟",
" - لعبة تشوف نفسك فنان فيها ؟",
" - اكثر مبلغ ضيعته ؟",
" - تعتمد على غيرك كثير ؟.",
" - ردة فعلك اذا احد قام يهاوشك بدون سبب ؟",
" - لو خيروك، سفرة عمل أو إجازة في البيت؟",
" - اكثر شي يعتمدون عليك فيه ؟",
" - موقفك من شخص أخفى عنك حقيقة ما، تخوفًا من خسارتك؟",
" - الوضع مع ابوك فله ولا رسمي؟",
" - ما الذي يرضي المرأه الغاضبه ؟",
" - كيف تتعامل مع الاشخاص السلبيين ؟",
" - تتكلم عن الشخص اللي تحبه قدام الناس ؟",
"مرتبط؟ ", 
"عندك فوبيا او خوف شديد من شيء معين ؟ ",
" غزل بلهجتك ؟ ",
" ردة فعلك لما تنظلم من شخص ؟ ",
"شيء تعترف انك فاشل فيه ؟ ",
"اكثر كلمة ترفع ضغطك ؟ ",
"نسبة جمال صوتك ؟ ",
"كيف تتعامل مع الشخص المُتطفل ( الفضولي , ؟ ",
"من الاشياء اللي تجيب لك الصداع ؟ ",
"حصلت الشخص اللي يفهمك ولا باقي ؟ ",
"تصرُّف ماتتحمله؟ ",
" صفة يطلقها عليك من حولك بكثرة؟ ",
" اسوء صفه فيك وتجاهد على تغييرها؟ ",
"شاركنا أقوى بيت شِعر من تأليفك؟ ",
"ماذا لو عاد معتذراً؟ ",
"تقطع علاقتك بالشخص إذا عرفت إنه...؟ ",
" كلام ودك يوصل للشخص المطلوب ؟ ",
".ردة فعلك لمن يتجاهلك بالرد متعمد؟ ",
"كم نسبة البيتوتية في شخصيتك؟ ",
" متى تحس أنك فعلًا أنسان صبور جدًا ؟ ",
" هل أنت من النوع الذي يواجه المشاكل أو من النوع الذي يهرب ؟ ",
" أمنية كنت تتمناها وحققتها ؟ ",
" تملك وسواس من شيء معين ؟ ",
"عمرك انتقمت من أحد ؟! ",
"متى تقرر تنسحب من أي علاقة ؟ ",
"كلمتريكس تكررها دايم ؟! ",
"افضل هديه ممكن تناسبك؟ ",
" انت حزين اول شخص تتصل عليه؟ ",
"موقف خلاك تحس انك مكسور ؟ ",
"ماذا لو كانت مشاعر البشر مرئية ؟ ",
"كم تشوف انك تستحق فرصه؟ ",
"يهمك ظن الناس فيك ولا ؟ ",
"اغنية عندك معاها ذكريات ",
" موقف غير حياتك؟ ",
"اكثر مشروب تحبه؟ ",
"القصيدة اللي تأثر فيك؟ ",
"متى يصبح الصديق غريب ",
"هل وصلك رسالة غير متوقعة من شخص وأثرت فيك ؟ ",
"وين نلقى السعاده برايك؟ ",
"تاريخ ميلادك؟ ",
" قهوه و لا شاي؟ ",
"من محبّين الليل أو الصبح؟ ",
"حيوانك المفضل؟ ",
"كلمة غريبة ومعناها؟ ",
"هل التعود على شخص والتحدث معه بشكل يومي يعتبر نوع من أنواع الحب؟ ",
"كم تحتاج من وقت لتثق بشخص؟ ",
"اشياء نفسك تجربها؟ ",
"يومك ضاع على؟ ",
"كل شيء يهون الا ؟ ",
"اسم ماتحبه ؟ ",
"وقفة إحترام للي إخترع ؟ ",
"أقدم شيء محتفظ فيه من صغرك؟ ",
"كلمات ماتستغني عنها بسوالفك؟ ",
"وش الحب بنظرك؟ ",
"حب التملك في شخصِيـتك ولا ؟ ",
" تخطط للمستقبل ولا ؟ ",
"موقف محرج ماتنساه ؟ ",
"من طلاسم لهجتكم ؟ ",
"اعترف اللاعبين حاجه ؟ ",
"عبّر عن مودك بصوره ؟ ",
"اسم دايم ع بالك ؟ ",
"اشياء تفتخر انك م سويتها ؟ ",
" لو بكيفي كان ؟ ",
" تحب تحتفظ بالذكريات ؟ ",
"اغلب وقتك ضايع في؟ ",
"اكثر كلمة تنقال لك بالبيت ؟ ",
"كلمتك التسليكيه ؟ ",
" تزعلك الدنيا ويرضيك ؟ ",
"ما السيء في هذه الحياة ؟ ",
"الفلوس او الحب ؟",
" أجمل شيء حصل معك خلال هذا الاسبوع ؟ ",
" سؤال ينرفزك ؟ ",
" كم في حسابك البنكي ؟ ",
"اكثر ممثل تحبه ؟ ",
" قد تخيلت شي في بالك وصار ؟ ",
"كلمة لشخص أسعدك رغم حزنك في يومٍ من الأيام ؟ ",
"شيء عندك اهم من الناس ؟ ",
" اول ولد لك وش راح تسميه ؟ ",
" تفضّل النقاش الطويل او تحب الاختصار ؟ ",
"وش أخر شي ضيعته؟ ",
"عادي تتزوج من برا القبيلة؟ ",
"كم مره حبيت؟ ",
"تبادل الكراهية بالكراهية؟ ولا تحرجه بالطيب؟",
"لو فزعت/ي لصديق/ه وقالك مالك دخل وش بتسوي/ين؟",
"قلبي على قلبك مهما صار لمين تقولها؟",
"نسبة النعاس عندك حاليًا؟",
"نسبه الندم عندك للي وثقت فيهم ؟",
"وش اسم اول شخص تعرفت عليه فالتلقرام ؟",
"جربت شعور احد يحبك بس انت مو قادر تحبه؟",
"تجامل الناس ولا اللي بقلبك على لسانك؟",
"عمرك ضحيت باشياء لاجل شخص م يسوى ؟",
"مغني تلاحظ أن صوته يعجب الجميع إلا أنت؟ ",
"خر غلطات عمرك؟ ",
"مسلسل كرتوني له ذكريات جميلة عندك؟ ",
"ما أكثر تطبيق تقضي وقتك عليه؟ ",
"ول شيء يخطر في بالك إذا سمعت كلمة نجوم ؟ ",
"قدوتك من الأجيال السابقة؟ ",
"كثر طبع تهتم بأن يتواجد في شريك/ة حياتك؟ ",
" أكثر حيوان تخاف منه؟ ",
"ما هي طريقتك في الحصول على الراحة النفسية؟ ",
"إيموجي يعبّر عن مزاجك الحالي؟ ",
"أكثر تغيير ترغب أن تغيّره في نفسك؟ ",
" أكثر شيء أسعدك اليوم؟ ",
"بماذا يتعافى المرء؟ ",
" ما هو أفضل حافز للشخص؟ ",
"ما الذي يشغل بالك في الفترة الحالية؟",
".آخر شيء ندمت عليه؟ ",
"كتاب أو رواية تقرأها هذه الأيام؟ ",
"فيلم عالق في ذهنك لا تنساه مِن روعته؟ ",
"يوم لا يمكنك نسيانه؟ ",
"شعورك الحالي في جملة؟ ",
"أكثر سبب منطقي يمكن أن يبكيك",
"تقرر الإبتعاد عن الشخص الذي تُحب؟ ",
" كلمة لشخص بعيد؟ ",
"صفة يطلقها عليك الشخص المفضّله",
" أغنية عالقة في ذهنك هاليومين؟ ",
"أكلة مستحيل أن تأكلها؟ ",
"كيف قضيت نهارك؟ ",
"انت من الناس المؤدبة ولا نص نص؟ ",
  "كيف الصيد معاك هالأيام ؟ وسنارة ولاشبك؟ ",
  "لو الشخص اللي تحبه قال بدخل حساباتك بتعطيه ولا تكرشه؟ ",
  "أكثر شي تخاف منه بالحياه وش؟ ",
  "متى يوم ميلادك؟ ووش الهدية اللي نفسك فيه؟ ",
  "قد تمنيت شي وتحقق؟ ",
  "قلبي على قلبك مهما صار لمين تقولها؟ ",
  "وش نوع جوالك؟ واذا بتغيره وش بتأخذ؟ ",
  "كم حساب عندك بالتليجرام؟ ",
  "متى اخر مرة كذبت؟ ",
"كذبت في الاسئلة اللي مرت عليك قبل شوي؟ ",
  "تجامل الناس ولا اللي بقلبك على لسانك؟ ",
  "قد تمصلحت مع أحد وليش؟ ",
  "وين تعرفت على الشخص اللي حبيته؟ ",
  "قد رقمت او احد رقمك؟ ",
  "وش أفضل لعبته بحياتك؟ ",
  "أخر شي اكلته وش هو؟ ",
  "حزنك يبان بملامحك ولا صوتك؟ ",
  "لقيت الشخص اللي يفهمك واللي يقرا افكارك؟ ",
  "فيه شيء م تقدر تسيطر عليه ؟ ",
  "منشن شخص متحلطم م يعجبه شيء؟ ",
"اكتب تاريخ مستحيل تنساه ",
  "شيء مستحيل انك تاكله ؟ ",
  "تحب تتعرف على ناس جدد ولا مكتفي باللي عندك ؟ ",
  "انسان م تحب تتعامل معاه ابداً ؟ ",
  "شيء بسيط تحتفظ فيه؟ ",
  "فُرصه تتمنى لو أُتيحت لك ؟ ",
  "شيء مستحيل ترفضه ؟. ",
  "لو زعلت بقوة وش بيرضيك ؟ ",
  "تنام بـ اي مكان ، ولا بس غرفتك ؟ ",
  "ردك المعتاد اذا أحد ناداك ؟ ",
  "مين الي تحب يكون مبتسم دائما ؟ ",
" إحساسك في هاللحظة؟ ",
  "وش اسم اول شخص تعرفت عليه فالتلقرام ؟ ",
  "اشياء صعب تتقبلها بسرعه ؟ ",
  "شيء جميل صار لك اليوم ؟ ",
  "اذا شفت شخص يتنمر على شخص قدامك شتسوي؟ ",
  "يهمك ملابسك تكون ماركة ؟ ",
  "ردّك على شخص قال (أنا بطلع من حياتك,؟. ",
  "مين اول شخص تكلمه اذا طحت بـ مصيبة ؟ ",
  "تشارك كل شي لاهلك ولا فيه أشياء ما تتشارك؟ ",
  "كيف علاقتك مع اهلك؟ رسميات ولا ميانة؟ ",
  "عمرك ضحيت باشياء لاجل شخص م يسوى ؟ ",
"اكتب سطر من اغنية او قصيدة جا فـ بالك ؟ ",
  "شيء مهما حطيت فيه فلوس بتكون مبسوط ؟ ",
  "مشاكلك بسبب ؟ ",
  "نسبه الندم عندك للي وثقت فيهم ؟ ",
  "اول حرف من اسم شخص تقوله? بطل تفكر فيني ابي انام؟ ",
  "اكثر شيء تحس انه مات ف مجتمعنا؟ ",
  "لو صار سوء فهم بينك وبين شخص هل تحب توضحه ولا تخليه كذا  لان مالك خلق توضح ؟ ",
  "كم عددكم بالبيت؟ ",
  "أجمل شي بحياتك وش هو؟ ",
} 
bot.sendText(msg.chat_id,msg.id,texting[math.random(#texting)],'md', true)
end

if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":link:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":link:add")
if text and text:match("^https://t.me/+(.*)$") then     
redis:set(bot_id..":"..msg.chat_id..":link",text)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم حفظ الرابط الجديد بنجاح .*","md", true)
else
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذرا الرابط خطأ ارسل رابط صالح .*","md", true)
end
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":iid:adds") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":iid:adds")
redis:set(bot_id..":iid",text)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم حفظ الايدي العام الجديد *","md", true)
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":id:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":id:add")
redis:set(bot_id..":"..msg.chat_id..":id",text)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم حفظ الايدي الجديد *","md", true)
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":we:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":we:add")
redis:set(bot_id..":"..msg.chat_id..":Welcome",text)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم حفظ الترحيب الجديد *","md", true)
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":nameGr:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":nameGr:add")
if GetInfoBot(msg).Info == false then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ ليس لدي صلاحيات تغيير المعلومات*',"md",true)  
return false
end
bot.setChatTitle(msg.chat_id,text)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم تغيير الاسم *","md", true)
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":decGr:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":decGr:add")
if GetInfoBot(msg).Info == false then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ ليس لدي صلاحيات تغيير المعلومات*',"md",true)  
return false
end
bot.setChatDescription(msg.chat_id,text)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم تغيير الوصف *","md", true)
end
if BasicConstructor(msg) then
if text == 'تغيير اسم الكروب' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":nameGr:add",true)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسل الاسم الجديد الان*","md", true)
end
if text == 'تغيير الوصف' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":decGr:add",true)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسل الوصف الجديد الان*","md", true)
end
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":law:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":law:add")
redis:set(bot_id..":"..msg.chat_id..":Law",text)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم حفظ القوانين *","md", true)
end
if Owner(msg) then
if text == 'تعين قوانين' or text == 'تعيين قوانين' or text == 'وضع قوانين' or text == 'اضف قوانين' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":law:add",true)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسل القوانين الان*","md", true)
end
if text == 'مسح القوانين' or text == 'حذف القوانين' then
redis:del(bot_id..":"..msg.chat_id..":Law")
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم "..text.." *","md", true)
end
if text == "تنظيف الروابط" or text == "مسح الروابط" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ يتم البحث عن روابط .*","md",true)  
msgid = (msg.id - (1048576*250))
y = 0
r = 1048576
for i=1,250 do
r = r + 1048576
Delmsg = bot.getMessage(msg.chat_id,msgid + r)
if Delmsg and Delmsg.content and Delmsg.content.text then
textlin = Delmsg.content.text.text
else
textlin = nil
end
if textlin and textlin:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or 
textlin and textlin:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or 
textlin and textlin:match("[Tt].[Mm][Ee]/") or
textlin and textlin:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or 
textlin and textlin:match(".[Pp][Ee]") or 
textlin and textlin:match("[Hh][Tt][Tt][Pp][Ss]://") or 
textlin and textlin:match("[Hh][Tt][Tt][Pp]://") or 
textlin and textlin:match("[Ww][Ww][Ww].") or 
textlin and textlin:match(".[Cc][Oo][Mm]") or 
textlin and textlin:match("[Hh][Tt][Tt][Pp][Ss]://") or 
textlin and textlin:match("[Hh][Tt][Tt][Pp]://") or 
textlin and textlin:match("[Ww][Ww][Ww].") or 
textlin and textlin:match(".[Cc][Oo][Mm]") or 
textlin and textlin:match(".[Tt][Kk]") or 
textlin and textlin:match(".[Mm][Ll]") or 
textlin and textlin:match("[Oo][Kk]") or 
textlin and textlin:match(".[Pp][Oo][Rr][Nn]") or 
textlin and textlin:match(".[Xx][Xx][Xx]") or 
textlin and textlin:match("[Xx][Xx][Xx]") or 
textlin and textlin:match(".[Tt][Vv]") or 
textlin and textlin:match(".[Mm][Oo][Bb][Ii]") or 
textlin and textlin:match(".[Dd][Ee][Ss][Ii]") or 
textlin and textlin:match(".[Pp][Hh]") or 
textlin and textlin:match(".[Oo][Rr][Gg]") then 
bot.deleteMessages(msg.chat_id,{[1]= Delmsg.id}) 
y = y + 1
end
end
if y == 0 then 
t = "*⤈︙ لم يتم العثور على روابط ضمن 250 رساله السابقه*"
else
t = "*⤈︙ تم حذف ( "..y.." ) من الروابط *"
end
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).yu, 'md', true, false, false, false, reply_markup)
end
if text == "تنظيف روابط الاعضاء" or text == "مسح روابط الاعضاء" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ يتم البحث عن روابط الاعضاء .*","md",true)  
msgid = (msg.id - (1048576*250))
y = 0
r = 1048576
for i=1,250 do
r = r + 1048576
Delmsg = bot.getMessage(msg.chat_id,msgid + r)
if Delmsg and Delmsg.content and Delmsg.content.text then
textlin = Delmsg.content.text.text
else
textlin = nil
end
if textlin and textlin:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or 
textlin and textlin:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or 
textlin and textlin:match("[Tt].[Mm][Ee]/") or
textlin and textlin:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or 
textlin and textlin:match(".[Pp][Ee]") or 
textlin and textlin:match("[Hh][Tt][Tt][Pp][Ss]://") or 
textlin and textlin:match("[Hh][Tt][Tt][Pp]://") or 
textlin and textlin:match("[Ww][Ww][Ww].") or 
textlin and textlin:match(".[Cc][Oo][Mm]") or 
textlin and textlin:match("[Hh][Tt][Tt][Pp][Ss]://") or 
textlin and textlin:match("[Hh][Tt][Tt][Pp]://") or 
textlin and textlin:match("[Ww][Ww][Ww].") or 
textlin and textlin:match(".[Cc][Oo][Mm]") or 
textlin and textlin:match(".[Tt][Kk]") or 
textlin and textlin:match(".[Mm][Ll]") or 
textlin and textlin:match("[Oo][Kk]") or 
textlin and textlin:match(".[Pp][Oo][Rr][Nn]") or 
textlin and textlin:match(".[Xx][Xx][Xx]") or 
textlin and textlin:match("[Xx][Xx][Xx]") or 
textlin and textlin:match(".[Tt][Vv]") or 
textlin and textlin:match(".[Mm][Oo][Bb][Ii]") or 
textlin and textlin:match(".[Dd][Ee][Ss][Ii]") or 
textlin and textlin:match(".[Pp][Hh]") or 
textlin and textlin:match(".[Oo][Rr][Gg]") then 
bot.deleteMessages(msg.chat_id,{[1]= Delmsg.id}) 
y = y + 1
end
end
if y == 0 then 
t = "*⤈︙ لم يتم العثور على روابط الاعضاء ضمن 250 رساله سابقه .*"
else
t = "*⤈︙ تم حذف ( "..y.." ) من روابط الاعضاء *"
end
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).yu, 'md', true, false, false, false, reply_markup)
end
if text == "تنظيف المعرفات" or text == "مسح المعرفات" or text == "مسح التاكات"  or text == "تنظيف التاكات" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ يتم البحث عن المعرفات .*","md",true)  
msgid = (msg.id - (1048576*250))
y = 0
r = 1048576
for i=1,250 do
r = r + 1048576
Delmsg = bot.getMessage(msg.chat_id,msgid + r)
if Delmsg and Delmsg.content and Delmsg.content.text then
textlin = Delmsg.content.text.text
else
textlin = nil
end
if textlin and textlin:match("[@]") then 
bot.deleteMessages(msg.chat_id,{[1]= Delmsg.id}) 
y = y + 1
end
end
if y == 0 then 
t = "*⤈︙ لم يتم العثور على معرفات ضمن 250 رساله السابقه*"
else
t = "*⤈︙ تم حذف ( "..y.." ) من المعرفات *"
end
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).yu, 'md', true, false, false, false, reply_markup)
end
---------------------------------------
if text == "تنظيف الهاشتاك" or text == "مسح الهاشتاك" or text == "مسح الهاشتاكات"  or text == "تنظيف الهاشتاكات" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ يتم البحث عن الهاشتاكات .*","md",true)  
msgid = (msg.id - (1048576*250))
y = 0
r = 1048576
for i=1,250 do
r = r + 1048576
Delmsg = bot.getMessage(msg.chat_id,msgid + r)
if Delmsg and Delmsg.content and Delmsg.content.text then
textlin = Delmsg.content.text.text
else
textlin = nil
end
if textlin and textlin:match("[#]") then 
bot.deleteMessages(msg.chat_id,{[1]= Delmsg.id}) 
y = y + 1
end
end
if y == 0 then 
t = "*⤈︙ لم يتم العثور على معرفات ضمن 250 رساله السابقه*"
else
t = "*⤈︙ تم حذف ( "..y.." ) من الهاشتاكات *"
end
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).yu, 'md', true, false, false, false, reply_markup)
end
if text == "تنظيف التعديل" or text == "مسح التعديل" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ يتم البحث عن الرسائل المعدله*","md",true)
msgid = (msg.id - (1048576*250))
y = 0
r = 1048576
for i=1,250 do
r = r + 1048576
Delmsg = bot.getMessage(msg.chat_id,msgid + r)
if Delmsg and Delmsg.edit_date and Delmsg.edit_date ~= 0 then
bot.deleteMessages(msg.chat_id,{[1]= Delmsg.id}) 
y = y + 1
end
end
if y == 0 then 
t = "*⤈︙ لم يتم العثور على الرسائل المعدله ضمن 250 رساله السابقه*"
else
t = "*⤈︙ تم مسح ( "..y.." ) من الرسائل المعدله *"
end
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).yu, 'md', true, false, false, false, reply_markup)
end
if text == "تنظيف الميديا" or text == "مسح الميديا" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ يتم البحث عن الميديا*","md",true)
msgid = (msg.id - (1048576*250))
y = 0
r = 1048576
for i=1,250 do
r = r + 1048576
Delmsg = bot.getMessage(msg.chat_id,msgid + r)
if Delmsg and Delmsg.content and Delmsg.content.luatele ~= "messageText" then
bot.deleteMessages(msg.chat_id,{[1]= Delmsg.id}) 
y = y + 1
end
end
if y == 0 then 
t = "*⤈︙ لم يتم العثور على الميديا ضمن 250 رساله السابقه*"
else
t = "*⤈︙ تم مسح ( "..y.." ) من الميديا *"
end
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).yu, 'md', true, false, false, false, reply_markup)
end
if text == 'رفع الادمنيه' then
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ البوت لا يملك صلاحيات*","md",true)  
return false
end
local info_ = bot.getSupergroupMembers(msg.chat_id, "Administrators", "*", 0, 200)
local list_ = info_.members
y = 0
for k, v in pairs(list_) do
if info_.members[k].bot_info == nil then
if info_.members[k].status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",v.member_id.user_id) 
else
redis:sadd(bot_id..":"..msg.chat_id..":Status:Administrator",v.member_id.user_id) 
y = y + 1
end
end
end
bot.sendText(msg.chat_id,msg.id,'*⤈︙ تم رفع ( '..y..' ) ادمن بالمجموعه*',"md",true)  
end
if text == 'تعين ترحيب' or text == 'تعيين ترحيب' or text == 'وضع ترحيب' or text == 'ضع ترحيب' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":we:add",true)
local reply_markup = bot.replyMarkup{
    type = 'inline',
    data = {
    {
    {text = '‹ الغاء ›', data = msg.sender_id.user_id..'/cancelamr'},
    },
    }
    }
    bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسل الان الترحيب الجديد .\n⤈︙ يمكنك اضافه .*\n⤈︙ `user` > *يوزر المستخدم .*\n⤈︙ `name` > *اسم المستخدم .*","md", false, false, false, false, reply_markup)
 end 
if text == 'الترحيب' then
if redis:get(bot_id..":"..msg.chat_id..":Welcome") then
t = redis:get(bot_id..":"..msg.chat_id..":Welcome")
else 
t = "*⤈︙ لم يتم وضع ترحيب*"
end
bot.sendText(msg.chat_id,msg.id,t,"md", true)
end
if text == 'مسح الترحيب' or text == 'حذف الترحيب' then
redis:del(bot_id..":"..msg.chat_id..":Welcome")
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم "..text.." بنجاح .*","md", true)
end
if text == 'مسح الايدي' or text == 'حذف الايدي' then
redis:del(bot_id..":"..msg.chat_id..":id")
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم "..text.." الجديد بنجاح .*","md", true)
end
if text == 'تعين الايدي' or text == 'تعيين الايدي' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":id:add",true)
local reply_markup = bot.replyMarkup{
    type = 'inline',
    data = {
    {
    {text = '‹ الغاء ›', data = msg.sender_id.user_id..'/cancelamr'},
    },
    }
    }
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسل الان النص\n⤈︙ يمكنك اضافه :*\n⤈︙ `#name` > *اسم المستخدم*\n⤈︙ `[#username]` > *يوزر المستخدم*\n⤈︙ `#msgs` > *عدد رسائل المستخدم*\n⤈︙ `#photos` > *عدد صور المستخدم*\n⤈︙ `#id` > *ايدي المستخدم*\n⤈︙ `#auto` > *تفاعل المستخدم*\n⤈︙ `#stast` > *موقع المستخدم* \n⤈︙ `#edit` > *عدد التعديلات*\n⤈︙ `#AddMem` > *عدد الجهات*\n⤈︙ `#Description` > *تعليق الصوره*","md", false, false, false, false, reply_markup)
end
if text == "تغيير الايدي" or text == "تغير الايدي" then 
local ListIDtxt = {'◇︰Msgs : #msgs .\n◇︰ID : #id .\n◇︰Stast : #stast .\n◇︰UserName : #username .\n','˛ َ𝖴ᥱ᥉ : #username  .\n˛ َ𝖲𝗍ُɑِ  : #stast   . \n˛ َ𝖨ժ : #id  .\n˛ َ𝖬⁪⁬⁮᥉𝗀ِ : #msgs   .\n','⚕ 𓆰 𝑾𝒆𝒍𝒄𝒐𝒎𝒆 𝑻𝒐 𝑮𝒓𝒐𝒖𝒑 ★\n- 🖤 | 𝑼𝑬𝑺 : #username\n- 🖤 | 𝑺𝑻𝑨 : #stast\n- 🖤 | 𝑰𝑫 : #id\n- 🖤 | 𝑴𝑺𝑮 : #msgs\n','◇︰𝖬𝗌𝗀𝗌 : #msgs  .\n◇︰𝖨𝖣 : #id  .\n◇︰𝖲𝗍𝖺𝗌𝗍 : #stast .\n◇︰UserName : #username .\n','⌁ Use ⇨{#username}\n⌁ Msg⇨ {#msgs}\n⌁ Sta ⇨ {#stast}\n⌁ iD ⇨{#id}\n▿▿▿','゠𝚄𝚂𝙴𝚁 𖨈 #username 𖥲 .\n゠𝙼𝚂𝙶 𖨈 #msgs 𖥲 .\n゠𝚂𝚃𝙰 𖨈 #stast 𖥲 .\n゠𝙸𝙳 𖨈 #id 𖥲 .\n','\n▹ 𝙐𝙎𝙀𝙍 𖨄 #username  𖤾.\n▹ 𝙈𝙎𝙂𝙎 𖨄 #msgs  𖤾.\n▹ 𝙎𝙏𝘼𝙎𝙏 𖨄 #stast  𖤾.\n▹ 𝙄𝘿 ?? #id 𖤾.\n','\n➼ : 𝐼𝐷 𖠀 #id\n➼ : 𝑈𝑆𝐸𝑅 𖠀 #username\n➼ : 𝑀𝑆𝐺𝑆 𖠀 #msgs\n➼ : 𝑆𝑇𝐴S𝑇 𖠀 #stast\n➼ : 𝐸𝐷𝐼𝑇  𖠀 #edit\n','\n┌ 𝐔𝐒𝐄𝐑 𖤱 #username 𖦴 .\n├ 𝐌𝐒𝐆𝐒 𖤱 #msgs 𖦴 .\n├ 𝐒𝐓𝐀 𖤱 #stast 𖦴 .\n└ 𝐈𝐃 𖤱 #id 𖦴 .\n','\n୫ 𝙐𝙎𝙀𝙍𝙉𝘼𝙈𝙀 ➤ #username\n୫ 𝙈𝙀𝙎𝙎𝘼𝙂𝙀𝙎 ➤ #msgs\n୫ 𝙎𝙏𝘼𝙏𝙎 ➤ #stast\n୫ 𝙄𝘿 ➤ #id\n','\n☆-𝐮𝐬𝐞𝐫 : #username 𖣬\n☆-𝐦𝐬𝐠  : #msgs 𖣬\n☆-𝐬𝐭𝐚 : #stast 𖣬\n☆-𝐢𝐝  : #id 𖣬\n','\n𝐘𝐨𝐮𝐫 𝐈𝐃 ☤🇮🇶- #id\n𝐔𝐬𝐞𝐫𝐍𝐚☤🇮🇶- #username\n𝐒𝐭𝐚𝐬𝐓 ☤🇮🇶- #stast\n𝐌𝐬𝐠𝐒☤🇮🇶 - #msgs\n','\n.𖣂 𝙪𝙨𝙚𝙧𝙣𝙖𝙢𝙚 , #username\n.𖣂 𝙨𝙩𝙖𝙨𝙩 , #stast\n.𖣂 𝙄𝘿 , #id\n.𖣂 𝙂𝙖𝙢𝙨 , #game\n.𖣂 𝙢𝙨𝙂𝙨 , #msgs\n'}
nListIDtxt = math.random(1,#ListIDtxt)
Text_Rand = ListIDtxt[nListIDtxt]
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ هل تريد تعيين هذهِ الكليشة للايدي .*\n"..Text_Rand.."\n)").yu,"md", true, false, false, false, bot.replyMarkup{type = 'inline',data = {{{text ='‹ تأكيد ›',data="EditIdDone_"..msg.sender_id.user_id.."_"..nListIDtxt},{text = '‹ تخطي ›',data="EditIdskip_"..msg.sender_id.user_id.."_"..nListIDtxt}},{{text = '‹ الغاء ›',data="Sur_"..msg.sender_id.user_id.."_2"}},}})
end
if text == 'مسح الرابط' or text == 'حذف الرابط' then
redis:del(bot_id..":"..msg.chat_id..":link")
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم "..text.." بنجاح .*","md", true)
end
if text == 'تعين الرابط' or text == 'تعيين الرابط' or text == 'وضع رابط' or text == 'تغيير الرابط' or text == 'تغير الرابط' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":link:add",true)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ قم بارسال الرابط الجديد الان .*","md", true)
end
if text == 'انشاء رابط' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":link:add",true)
local reply_markup = bot.replyMarkup{
    type = 'inline',
    data = {
    {
    {text = '‹ الغاء ›', data = msg.sender_id.user_id..'/cancelamr'},
    },
    }
    }
bot.sendText(msg.chat_id,msg.id,"*⤈︙ ارسل الرابط الان .\n⤈︙ لتكتمل عملية انشاء الرابط .*","md", false, false, false, false, reply_markup)
end
if text == 'فحص البوت' then 
local StatusMember = bot.getChatMember(msg.chat_id,bot_id).status.luatele
if (StatusMember ~= "chatMemberStatusAdministrator") then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ البوت عضو في المجموعه*',"md",true) 
return false
end
local GetMemberStatus = bot.getChatMember(msg.chat_id,bot_id).status
if GetMemberStatus.can_change_info then
change_info = '✅️️' else change_info = '❌️'
end
if GetMemberStatus.can_delete_messages then
delete_messages = '✅️️' else delete_messages = '❌️'
end
if GetMemberStatus.can_invite_users then
invite_users = '✅️️' else invite_users = '❌️'
end
if GetMemberStatus.can_pin_messages then
pin_messages = '✅️️' else pin_messages = '❌️'
end
if GetMemberStatus.can_restrict_members then
restrict_members = '✅️️' else restrict_members = '❌️'
end
if GetMemberStatus.can_promote_members then
promote = '✅️️' else promote = '❌️'
end
PermissionsUser = '*\n⤈︙ صلاحيات البوت في المجموعه :\n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉'..'\n⤈︙ تغيير المعلومات : '..change_info..'\n⤈︙ تثبيت الرسائل : '..pin_messages..'\n⤈︙ اضافه مستخدمين : '..invite_users..'\n⤈︙ مسح الرسائل : '..delete_messages..'\n⤈︙ حظر المستخدمين : '..restrict_members..'\n⤈︙ اضافه المشرفين : '..promote..'\n\n*'
bot.sendText(msg.chat_id,msg.id,PermissionsUser,"md",true) 
return false
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:delmsg") then
if text == ("امسح") and BasicConstructor(msg) then  
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
if redis:get(bot_id..":"..msg.chat_id..":Amsh") then
return bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم تعطيل امسح بواسطه المالك .*","md",true)  
end
local list = redis:smembers(bot_id..":"..msg.chat_id..":mediaAude:ids")
for k,v in pairs(list) do
local Message = v
if Message then
t = "⤈︙ تم مسح "..k.." من الوسائط الموجوده"
bot.deleteMessages(msg.chat_id,{[1]= Message})
redis:del(bot_id..":"..msg.chat_id..":mediaAude:ids")
end
end
if #list == 0 then
t = "⤈︙ لا يوجد ميديا في المجموعه ."
end
Text = Reply_Status(msg.sender_id.user_id,"*"..t.."*").by
bot.sendText(msg.chat_id,msg.id,Text,"md",true, false, false, false, reply_markup)
end
if text and text:match('^مسح (%d+)$') then
local NumMessage = text:match('^مسح (%d+)$')
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ البوت ليس ادمن في الكروب*","md",true)  
return false
end
if GetInfoBot(msg).Delmsg == false then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ البوت لا يمتلك صلاحيه مسح الرسائل*","md",true)  
return false
end
if tonumber(NumMessage) > 1000 then
bot.sendText(msg.chat_id,msg.id,'* لا تستطيع مسح اكثر من 1000 رساله*',"md",true)  
return false
end
local Message = msg.id
for i=1,tonumber(NumMessage) do
bot.deleteMessages(msg.chat_id,{[1]= Message})
Message = Message - 1048576
end
bot.sendText(msg.chat_id, msg.id,"*⤈︙  مسحت ( "..NumMessage.." ) رسالة *", 'md')
end
end

if text == "تنزيل جميع الرتب" or text == 'مسح الرتب' or text == 'حذف الرتب' and tonumber(msg.reply_to_message_id) == 0 then
local StatusMember = bot.getChatMember(msg.chat_id,msg.sender_id.user_id).status.luatele
local Info_Members1 = redis:smembers(bot_id..":"..msg.chat_id..":Status:BasicConstructor") 
local Info_Members2 = redis:smembers(bot_id..":"..msg.chat_id..":Status:Constructor") 
local Info_Members3 = redis:smembers(bot_id..":"..msg.chat_id..":Status:Owner") 
local Info_Members4 = redis:smembers(bot_id..":"..msg.chat_id..":Status:Administrator") 
local Info_Members5 = redis:smembers(bot_id..":"..msg.chat_id..":Status:Vips") 
redis:del(bot_id..":"..msg.chat_id..":Status:BasicConstructor") 
redis:del(bot_id..":"..msg.chat_id..":Status:Constructor") 
redis:del(bot_id..":"..msg.chat_id..":Status:Owner") 
redis:del(bot_id..":"..msg.chat_id..":Status:Administrator") 
redis:del(bot_id..":"..msg.chat_id..":Status:Vips")
if #Info_Members1 == 0 and #Info_Members2 == 0 and #Info_Members3 == 0 and #Info_Members4 == 0 and #Info_Members5 == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu,"md",true)  
else
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم مسح جميع الرتب بنجاح .\nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ \n⤈︙ تم تنزيل ( "..#Info_Members1.." ) من المنشئين الاساسيين\n⤈︙ تم تنزيل ( "..#Info_Members2.." ) من المنشئين\n⤈︙ تم تنزيل ( "..#Info_Members3.." ) من المدراء\n⤈︙ تم تنزيل ( "..#Info_Members4.." ) من الادمن\n⤈︙ تم تنزيل ( "..#Info_Members5.." ) من المميزين *","md",true)
end
end
if text and text:match("^تغير رد المطور (.*)$") then
local Teext = text:match("^تغير رد المطور (.*)$") 
redis:set(bot_id.."Reply:developer"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم تغيير الرد الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المالك (.*)$") then
local Teext = text:match("^تغير رد المالك (.*)$") 
redis:set(bot_id..":Reply:Creator"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم تغيير الرد الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المنشئ الاساسي (.*)$") then
local Teext = text:match("^تغير رد المنشئ الاساسي (.*)$") 
redis:set(bot_id..":Reply:BasicConstructor"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم تغيير الرد الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المنشئ (.*)$") then
local Teext = text:match("^تغير رد المنشئ (.*)$") 
redis:set(bot_id..":Reply:Constructor"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم تغيير الرد الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المدير (.*)$") then
local Teext = text:match("^تغير رد المدير (.*)$") 
redis:set(bot_id..":Reply:Owner"..msg.chat_id,Teext) 
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم تغيير الرد الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد الادمن (.*)$") then
local Teext = text:match("^تغير رد الادمن (.*)$") 
redis:set(bot_id..":Reply:Administrator"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم تغيير الرد الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المميز (.*)$") then
local Teext = text:match("^تغير رد المميز (.*)$") 
redis:set(bot_id..":Reply:Vips"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم تغيير الرد الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد العضو (.*)$") then
local Teext = text:match("^تغير رد العضو (.*)$") 
redis:set(bot_id..":Reply:mem"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم تغيير الرد الى : *"..Teext.. "", 'md')
elseif text == 'مسح رد المطور' then
redis:del(bot_id..":Reply:developer"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم "..text.."*", 'md')
elseif text == 'مسح رد المالك' then
redis:del(bot_id..":Reply:Creator"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم "..text.." *", 'md')
elseif text == 'مسح رد المنشئ الاساسي' then
redis:del(bot_id..":Reply:BasicConstructor"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم "..text.." *", 'md')
elseif text == 'مسح رد المنشئ' then
redis:del(bot_id..":Reply:Constructor"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم "..text.."*", 'md')
elseif text == 'مسح رد المدير' then
redis:del(bot_id..":Reply:Owner"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم "..text.." *", 'md')
elseif text == 'مسح رد الادمن' then
redis:del(bot_id..":Reply:Administrator"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم "..text.." *", 'md')
elseif text == 'مسح رد المميز' then
redis:del(bot_id..":Reply:Vips"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم "..text.." *", 'md')
elseif text == 'مسح رد العضو' then
redis:del(bot_id..":Reply:mem"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم "..text.." *", 'md')
end
if text == 'الغاء تثبيت الكل' or text == 'الغاء التثبيت' then
if GetInfoBot(msg).PinMsg == false then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ ليس لدي صلاحيه تثبيت رسائل*',"md",true)  
return false
end
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم الغاء تثبيت جميع الرسائل المثبته*","md",true)
bot.unpinAllChatMessages(msg.chat_id) 
end
end
if BasicConstructor(msg) then
----------------------------------------------------------------------------------------------------
if text == "قائمه المنع" or text == "الممنوعات" or text == "المنع" then
local Photo =redis:scard(bot_id.."mn:content:Photo"..msg.chat_id) 
local Animation =redis:scard(bot_id.."mn:content:Animation"..msg.chat_id)  
local Sticker =redis:scard(bot_id.."mn:content:Sticker"..msg.chat_id)  
local Text =redis:scard(bot_id.."mn:content:Text"..msg.chat_id)  
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ الصور ›', data="mn_"..msg.sender_id.user_id.."_ph"},{text = '‹ الكلمات ›', data="mn_"..msg.sender_id.user_id.."_tx"}},
{{text = '‹ المتحركات ›', data="mn_"..msg.sender_id.user_id.."_gi"},{text = '‹ الملصقات ›',data="mn_"..msg.sender_id.user_id.."_st"}},
{{text = '‹ تحديث ›',data="mn_"..msg.sender_id.user_id.."_up"}},
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
bot.sendText(msg.chat_id,msg.id,"* ⤈︙ تحوي قائمه المنع على .\n⤈︙ الصور ( "..Photo.." ) .\n⤈︙ الكلمات ( "..Text.." ) .\n⤈︙ الملصقات  ( "..Sticker.." )\n⤈︙ المتحركات  ( "..Animation.." ) .\n⤈︙ اضغط على القائمه المراد حذفها .\nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ┉ ┉ *","md",true, false, false, false, reply_markup)
return false
end
if text == "مسح قائمه المنع" or text == "مسح الممنوعات" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم "..text.." بنجاح  .*","md",true)  
redis:del(bot_id.."mn:content:Text"..msg.chat_id) 
redis:del(bot_id.."mn:content:Sticker"..msg.chat_id) 
redis:del(bot_id.."mn:content:Animation"..msg.chat_id) 
redis:del(bot_id.."mn:content:Photo"..msg.chat_id) 
end
if text == "منع" and msg.reply_to_message_id == 0 then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ قم الان بارسال ( نص او الميديا ) لمنعه من المجموعه .*","md",true)  
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":mn:set",true)
end
if text == "منع" and msg.reply_to_message_id ~= 0 then
Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if Remsg.content.text then   
if redis:sismember(bot_id.."mn:content:Text"..msg.chat_id,Remsg.content.text.text) then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم منع الكلمه سابقا .*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Text"..msg.chat_id,Remsg.content.text.text)  
ty = "الرساله"
elseif Remsg.content.sticker then   
if redis:sismember(bot_id.."mn:content:Sticker"..msg.chat_id,Remsg.content.sticker.sticker.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم منع الملصق سابقا .*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Sticker"..msg.chat_id, Remsg.content.sticker.sticker.remote.unique_id)  
ty = "الملصق"
elseif Remsg.content.animation then
if redis:sismember(bot_id.."mn:content:Animation"..msg.chat_id,Remsg.content.animation.animation.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم منع المتحركه سابقا .*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Animation"..msg.chat_id, Remsg.content.animation.animation.remote.unique_id)  
ty = "المتحركه"
elseif Remsg.content.photo then
if redis:sismember(bot_id.."mn:content:Photo"..msg.chat_id,Remsg.content.photo.sizes[1].photo.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم منع الصوره سابقا .*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Photo"..msg.chat_id,Remsg.content.photo.sizes[1].photo.remote.unique_id)  
ty = "الصوره"
end
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم منع "..ty.." بنجاح .*","md",true)  
end
if text == "الغاء منع" and msg.reply_to_message_id ~= 0 then
Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if Remsg.content.text then   
redis:srem(bot_id.."mn:content:Text"..msg.chat_id,Remsg.content.text.text)  
ty = "الرساله"
elseif Remsg.content.sticker then   
redis:srem(bot_id.."mn:content:Sticker"..msg.chat_id, Remsg.content.sticker.sticker.remote.unique_id)  
ty = "الملصق"
elseif Remsg.content.animation then
redis:srem(bot_id.."mn:content:Animation"..msg.chat_id, Remsg.content.animation.animation.remote.unique_id)  
ty = "المتحركه"
elseif Remsg.content.photo then
redis:srem(bot_id.."mn:content:Photo"..msg.chat_id,Remsg.content.photo.sizes[1].photo.remote.unique_id)  
ty = "الصوره"
end
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم الغاء منع "..ty.." بنجاح .*","md",true)  
end
----------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
if msg and msg.content.text and msg.content.text.entities[1] and (msg.content.text.entities[1].luatele == "textEntity") and (msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName") then
if text and text:match('^كشف (.*)$') or text and text:match('^ايدي (.*)$') then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
local UserName = text:match('^كشف (.*)$') or text:match('^ايدي (.*)$')
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
sm = bot.getChatMember(msg.chat_id,usetid)
if sm.status.luatele == "chatMemberStatusCreator"  then
gstatus = "المالك الاساسي"
elseif sm.status.luatele == "chatMemberStatusAdministrator" then
gstatus = "المشرف"
else
gstatus = "عضو"
end
bot.sendText(msg.chat_id,msg.id,"*⤈︙ الايدي : *( `"..(usetid).."` *)*\n*⤈︙ الرتبه : *( `"..(Get_Rank(usetid,msg.chat_id)).."` *)*\n*⤈︙ الموقع : *( `"..(gstatus).."` *)*\n*⤈︙ عدد الرسائل : *( `"..(redis:get(bot_id..":"..msg.chat_id..":"..usetid..":message") or 1).."` *)*" ,"md",true, false, false, false, reply_markup)  
end
end
if Administrator(msg)  then
if text and text:match('^طرد (.*)$') then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ الطرد معطل من قبل المنشئين الاساسيين*").yu,"md",true)
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ البوت لا يمتلك صلاحيه طرد الاعضاء* ',"md",true)  
return false
end
if not Norank(usetid,msg.chat_id) then
t = "*⤈︙ لا يمكنك طرد "..Get_Rank(usetid,msg.chat_id).."*"
else
t = "*⤈︙ تم طرده بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,usetid,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).heloo,"md",true)    
end
end
if text and text:match("^تنزيل (.*) (.*)") and tonumber(msg.reply_to_message_id) == 0 then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
local infotxt = {text:match("^تنزيل (.*) (.*)")}
TextMsg = infotxt[1]
if msg.content.text then  
if TextMsg == 'مطور اساسي' then
srt = "Basic"
srt1 = ":"
elseif TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
if not redis:sismember(bot_id..srt1.."Status:"..srt,usetid) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*⤈︙ مو "..TextMsg.." من قبل*").heloo,"md",true)  
return false
end
if devB(msg.sender_id.user_id) then
if not redis:sismember(bot_id..srt1.."Status:"..srt,usetid) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*⤈︙ لا يمتلك رتبه بالفعل  .*").yu,"md",true)  
return false
end
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif Basic(msg) then
if not redis:sismember(bot_id..srt1.."Status:"..srt,usetid) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*⤈︙ لا يمتلك رتبه بالفعل  .*").yu,"md",true)  
return false
end
if TextMsg == 'مطور ثانوي' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*⤈︙ تم تنزيله من "..TextMsg.." بنجاح .*").heloo,"md",true)  
return false
end
end
end
if text and text:match("^رفع (.*) (.*)") and tonumber(msg.reply_to_message_id) == 0 then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
local infotxt = {text:match("^رفع (.*) (.*)")}
TextMsg = infotxt[1]
if msg.content.text then 
if TextMsg == 'مطور اساسي' then
srt = "Basic"
srt1 = ":"
elseif TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:Up") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ الرفع معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
if devB(msg.sender_id.user_id) then
if redis:sismember(bot_id..srt1.."Status:"..srt,usetid) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*⤈︙ تم رفعه سابقا .*").i,"md",true)  
return false
end
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif Basic(msg) then
if redis:sismember(bot_id..srt1.."Status:"..srt,usetid) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*⤈︙ تم رفعه سابقا .*").i,"md",true)  
return false
end
if TextMsg == 'مطور ثانوي' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مطور' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*⤈︙  تم رفعه "..TextMsg.." بنجاح .*").helo,"md",true)  
return false
end
end
end
if text and text:match("^تنزيل الكل (.*)") and tonumber(msg.reply_to_message_id) == 0 then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if Get_Rank(usetid,msg.chat_id)== "عضو" then
tt = "⤈︙ لا يمتلك رتبه لتنزيله "
else
tt = "⤈︙ تم تنزيله من جميع الرتب بنجاح"
end
if devB(msg.sender_id.user_id) then
redis:srem(bot_id..":Status:Basic",usetid)
redis:srem(bot_id..":Status:programmer",usetid)
redis:srem(bot_id..":Status:developer",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Basic(msg) then
redis:srem(bot_id..":Status:programmer",usetid)
redis:srem(bot_id..":Status:developer",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif programmer(msg) then
redis:srem(bot_id..":Status:developer",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif developer(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Creator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Creator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif BasicConstructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Constructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Owner(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Administrator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Vips(msg) then
return false
else
return false
end
if bot.getChatMember(msg.chat_id,usetid).status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",usetid)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*"..tt.."*").heloo,"md",true)  
return false
end
end
if text and text:match('^الغاء كتم (.*)$') or text and text:match('^الغاء الكتم (.*)$') then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*⤈︙ تم الغاء كتمه بنجاح . *"
redis:srem(bot_id..":"..msg.chat_id..":silent",usetid)
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).heloo,"md",true)  
end
end
if text and text:match('^كتم (.*)$') then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ الكتم معطل من قبل المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if not Norank(usetid,msg.chat_id) then
t = "*⤈︙ لا يمكنك كتم "..Get_Rank(usetid,msg.chat_id).."*"
else
t = "*⤈︙ تم كتمه بنجاح .*"
redis:sadd(bot_id..":"..msg.chat_id..":silent",usetid)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).heloo,"md",true)    
end
end
if text and text:match('^الغاء حظر (.*)$') then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
t = "*⤈︙ تم الغاء الحظر بنجاح . *"
redis:srem(bot_id..":"..msg.chat_id..":Ban",usetid)
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).heloo,"md",true)    
bot.setChatMemberStatus(msg.chat_id,usetid,'restricted',{1,1,1,1,1,1,1,1,1})
end
end
if text and text:match('^حظر (.*)$') then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ الحظر معطل من قبل المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ البوت لا يمتلك صلاحيه حظر الاعضاء* ',"md",true)  
return false
end
if not Norank(usetid,msg.chat_id) then
t = "*⤈︙ لا يمكنك حظر "..Get_Rank(usetid,msg.chat_id).."*"
else
t = "*⤈︙ تم حظره بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,usetid,'banned',0)
redis:sadd(bot_id..":"..msg.chat_id..":Ban",usetid)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).heloo,"md",true)    
end
end
end
end
----------------------------------------------------------------------------------------------------
if Administrator(msg)  then
----------------------------------------------------------------------------------------------------
if text and text:match('^رفع القيود @(%S+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^رفع القيود @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر لقناه او كروب تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", UserId_Info.id) then
redis:srem(bot_id..":"..msg.chat_id..":restrict",UserId_Info.id)
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", UserId_Info.id) then
redis:srem(bot_id..":"..msg.chat_id..":silent",UserId_Info.id)
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", UserId_Info.id) then
redis:srem(bot_id..":"..msg.chat_id..":Ban",UserId_Info.id)
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*⤈︙ تم رفع القيود عنه بنجاح .*").helo,"md",true)  
return false
end
if text and text:match('^رفع القيود (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^رفع القيود (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", UserName) then
redis:srem(bot_id..":"..msg.chat_id..":restrict",UserName)
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", UserName) then
redis:srem(bot_id..":"..msg.chat_id..":silent",UserName)
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", UserName) then
redis:srem(bot_id..":"..msg.chat_id..":Ban",UserName)
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*⤈︙ تم رفع القيود عنه بنجاح .*").helo,"md",true)  
return false
end
if text == "رفع القيود" and msg.reply_to_message_id ~= 0 then
Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", Remsg.sender_id.user_id) then
redis:srem(bot_id..":"..msg.chat_id..":restrict",Remsg.sender_id.user_id)
bot.setChatMemberStatus(msg.chat_id,Remsg.sender_id.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", Remsg.sender_id.user_id) then
redis:srem(bot_id..":"..msg.chat_id..":silent",Remsg.sender_id.user_id)
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", Remsg.sender_id.user_id) then
redis:srem(bot_id..":"..msg.chat_id..":Ban",Remsg.sender_id.user_id)
bot.setChatMemberStatus(msg.chat_id,Remsg.sender_id.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender_id.user_id,"*⤈︙ تم رفع القيود عنه بنجاح .*").helo,"md",true)  
return false
end
if text and text:match('^كشف القيود @(%S+)$') and tonumber(msg.reply_to_message_id) == 0 then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
local UserName = text:match('^كشف القيود @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر ليس لحساب شخصي تأكد منه*","md",true, false, false, false, reply_markup)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر لقناه او كروب تأكد منه*","md",true, false, false, false, reply_markup)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true, false, false, false, reply_markup)  
return false
end
if redis:sismember(bot_id..":bot:Ban", UserId_Info.id) then
Banal = "⤈︙ الحظر العام : ✅️️"
else
Banal = "⤈︙ الحظر العام : ❌️"
end
if redis:sismember(bot_id..":bot:silent", UserId_Info.id) then
silental  = "⤈︙ الكتم العام : ✅️️"
else
silental = "⤈︙ الكتم العام : ❌️"
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", UserId_Info.id) then
rict = "⤈︙ التقييد : ✅️️"
else
rict = "⤈︙ التقييد : ❌️"
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", UserId_Info.id) then
sent = "\n⤈︙ الكتم : ✅️️"
else
sent = "\n⤈︙ الكتم : ❌️"
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", UserId_Info.id) then
an = "\n⤈︙ الحظر : ✅️️"
else
an = "\n⤈︙ الحظر : ❌️"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id," *ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ \n"..Banal.."\n"..silental.."\n"..rict..""..sent..""..an.."*").i,"md",true, false, false, false, reply_markup)  
return false
end
if text and text:match('^كشف القيود (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
local UserName = text:match('^كشف القيود (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if redis:sismember(bot_id..":bot:Ban", UserName) then
Banal = "⤈︙ الحظر العام : ✅️️"
else
Banal = "⤈︙ الحظر العام : ❌️"
end
if redis:sismember(bot_id..":bot:silent", UserName) then
silental  = "⤈︙ الكتم العام : ✅️️"
else
silental = "⤈︙ الكتم العام : ❌️"
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", UserName) then
rict = "⤈︙ التقييد : ✅️️"
else
rict = "⤈︙ التقييد : ❌️"
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", UserName) then
sent = "\n⤈︙ الكتم : ✅️️"
else
sent = "\n⤈︙ الكتم : ❌️"
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", UserName) then
an = "\n⤈︙ الحظر : ✅️️"
else
an = "\n⤈︙ الحظر : ❌️"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ \n"..Banal.."\n"..silental.."\n"..rict..""..sent..""..an.."*").i,"md",true, false, false, false, reply_markup)  
return false
end
if text == "كشف القيود" and msg.reply_to_message_id ~= 0 then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if redis:sismember(bot_id..":bot:Ban", Remsg.sender_id.user_id) then
Banal = "⤈︙ الحظر العام : ✅️️"
else
Banal = "⤈︙ الحظر العام : ❌️"
end
if redis:sismember(bot_id..":bot:silent", Remsg.sender_id.user_id) then
silental  = "⤈︙ الكتم العام : ✅️️"
else
silental = "⤈︙ الكتم العام : ❌️"
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", Remsg.sender_id.user_id) then
rict = "⤈︙ لتقييد : ✅️️"
else
rict = "⤈︙ التقييد : ❌️"
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", Remsg.sender_id.user_id) then
sent = "\n⤈︙ الكتم : ✅️️"
else
sent = "\n⤈︙ الكتم : ❌️"
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", Remsg.sender_id.user_id) then
an = "\n⤈︙ الحظر : ✅️️"
else
an = "\n⤈︙ الحظر : ❌️"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender_id.user_id,"*ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ \n"..Banal.."\n"..silental.."\n"..rict..""..sent..""..an.."*").i,"md",true, false, false, false, reply_markup)  
return false
end
if text and text:match('^تقييد (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^تقييد (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ البوت لا يمتلك صلاحيه تقييد الاعضاء* ',"md",true)  
return false
end
if not Norank(UserName,msg.chat_id) then
t = "*⤈︙ لا يمكنك تقييد "..Get_Rank(UserName,msg.chat_id).." .*"
else
t = "*⤈︙ تم تقييده بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,0,0,0,0,0,0,0,0})
redis:sadd(bot_id..":"..msg.chat_id..":restrict",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^تقييد @(%S+)$') then
local UserName = text:match('^تقييد @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ البوت لا يمتلك صلاحيه تقييد الاعضاء* ',"md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
if not Norank(UserId_Info.id,msg.chat_id) then
t = "*⤈︙ لا يمكنك تقييد "..Get_Rank(UserId_Info.id,msg.chat_id).." .*"
else
t = "*⤈︙ تم تقييده بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,0,0,0,0,0,0,0,0})
redis:sadd(bot_id..":"..msg.chat_id..":restrict",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)    
end
if text == "تقييد" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender_id.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ البوت لا يمتلك صلاحيه تقييد الاعضاء* ',"md",true)  
return false
end
if not Norank(Remsg.sender_id.user_id,msg.chat_id) then
t = "*⤈︙ لا يمكنك تقييد "..Get_Rank(Remsg.sender_id.user_id,msg.chat_id).." .*"
else
t = "*⤈︙ تم تقييده بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,Remsg.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
redis:sadd(bot_id..":"..msg.chat_id..":restrict",Remsg.sender_id.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender_id.user_id,t).i,"md",true)    
end
if text and text:match('^الغاء تقييد (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء تقييد (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*⤈︙ تم الغاء تقييده بنجاح .*"
redis:srem(bot_id..":"..msg.chat_id..":restrict",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).yu,"md",true)    
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^الغاء تقييد @(%S+)$') then
local UserName = text:match('^الغاء تقييد @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
t = "*⤈︙ تم الغاء تقييده بنجاح .*"
redis:srem(bot_id..":"..msg.chat_id..":restrict",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).helo,"md",true)  
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text == "الغاء تقييد" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender_id.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
t = "*⤈︙ تم الغاء تقييده بنجاح .*"
redis:srem(bot_id..":"..msg.chat_id..":restrict",Remsg.sender_id.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender_id.user_id,t).helo,"md",true)    
bot.setChatMemberStatus(msg.chat_id,Remsg.sender_id.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^طرد (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^طرد (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ الطرد معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ البوت لا يمتلك صلاحيه طرد الاعضاء* ',"md",true)  
return false
end
if not Norank(UserName,msg.chat_id) then
t = "*⤈︙ لا يمكنك طرد "..Get_Rank(UserName,msg.chat_id).." .*"
else
t = "*⤈︙ تم طرده بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,UserName,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^طرد @(%S+)$') then
local UserName = text:match('^طرد @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ الطرد معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ البوت لا يمتلك صلاحيه طرد الاعضاء* ',"md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
if not Norank(UserId_Info.id,msg.chat_id) then
t = "*⤈︙ لا يمكنك طرد "..Get_Rank(UserId_Info.id,msg.chat_id).." .*"
else
t = "*⤈︙ تم طرده بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)    
end
if text == "طرد" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender_id.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ الطرد معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)
return false
end
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ البوت لا يمتلك صلاحيه طرد الاعضاء* ',"md",true)  
return false
end
if not Norank(Remsg.sender_id.user_id,msg.chat_id) then
t = "*⤈︙ لا يمكنك طرد "..Get_Rank(Remsg.sender_id.user_id,msg.chat_id).." .*"
else
t = "*⤈︙ تم طرده بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,Remsg.sender_id.user_id,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender_id.user_id,t).i,"md",true)    
end
if text and text:match('^حظر (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^حظر (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ الحظر معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ البوت لا يمتلك صلاحيه حظر الاعضاء* ',"md",true)  
return false
end
if not Norank(UserName,msg.chat_id) then
t = "*⤈︙ لا يمكنك حظر "..Get_Rank(UserName,msg.chat_id).." .*"
else
t = "*⤈︙ تم حظره بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,UserName,'banned',0)
redis:sadd(bot_id..":"..msg.chat_id..":Ban",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^حظر @(%S+)$') then
local UserName = text:match('^حظر @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ الحظر معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ البوت لا يمتلك صلاحيه حظر الاعضاء* ',"md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
if not Norank(UserId_Info.id,msg.chat_id) then
t = "*⤈︙ لا يمكنك حظر "..Get_Rank(UserId_Info.id,msg.chat_id).." .*"
else
t = "*⤈︙ تم حظره بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'banned',0)
redis:sadd(bot_id..":"..msg.chat_id..":Ban",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)    
end
if text == "حظر" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender_id.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ الحظر معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ البوت لا يمتلك صلاحيه حظر الاعضاء* ',"md",true)  
return false
end
if not Norank(Remsg.sender_id.user_id,msg.chat_id) then
t = "*⤈︙ لا يمكنك حظر "..Get_Rank(Remsg.sender_id.user_id,msg.chat_id).." .*"
else
t = "*⤈︙ تم حظره بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,Remsg.sender_id.user_id,'banned',0)
redis:sadd(bot_id..":"..msg.chat_id..":Ban",Remsg.sender_id.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender_id.user_id,t).i,"md",true)    
end
if text and text:match('^الغاء حظر (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء حظر (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*⤈︙ تم الغاء الحظر بنجاح .*"
redis:srem(bot_id..":"..msg.chat_id..":Ban",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).yu,"md",true)    
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^الغاء حظر @(%S+)$') then
local UserName = text:match('^الغاء حظر @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
t = "*⤈︙ تم الغاء الحظر بنجاح .*"
redis:srem(bot_id..":"..msg.chat_id..":Ban",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).helo,"md",true)  
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text == "الغاء حظر" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender_id.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
t = "*⤈︙ تم الغاء الحظر بنجاح .*"
redis:srem(bot_id..":"..msg.chat_id..":Ban",Remsg.sender_id.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender_id.user_id,t).helo,"md",true)    
bot.setChatMemberStatus(msg.chat_id,Remsg.sender_id.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^كتم (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^كتم (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ الكتم معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
if not Norank(UserName,msg.chat_id) then
t = "*⤈︙ لا يمكنك كتم "..Get_Rank(UserName,msg.chat_id).." .*"
else
t = "*⤈︙ تم كتمه بنجاح .*"
redis:sadd(bot_id..":"..msg.chat_id..":silent",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^كتم @(%S+)$') then
local UserName = text:match('^كتم @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ الكتم معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
if not Norank(UserId_Info.id,msg.chat_id) then
t = "*⤈︙ لا يمكنك كتم "..Get_Rank(UserId_Info.id,msg.chat_id).." .*"
else
t = "*⤈︙ تم كتمه بنجاح .*"
redis:sadd(bot_id..":"..msg.chat_id..":silent",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)    
end
if text == "كتم" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender_id.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ الكتم معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
if not Norank(Remsg.sender_id.user_id,msg.chat_id) then
t = "*⤈︙ لا يمكنك كتم "..Get_Rank(Remsg.sender_id.user_id,msg.chat_id).." .*"
else
t = "*⤈︙ تم كتمه بنجاح .*"
redis:sadd(bot_id..":"..msg.chat_id..":silent",Remsg.sender_id.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender_id.user_id,t).i,"md",true)    
end
if text and text:match('^الغاء كتم (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء كتم (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*⤈︙ تم الغاء كتمه بنجاح .*"
redis:srem(bot_id..":"..msg.chat_id..":silent",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).yu,"md",true)    
end
if text and text:match('^الغاء كتم @(%S+)$') then
local UserName = text:match('^الغاء كتم @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
t = "*⤈︙ تم الغاء كتمه بنجاح .*"
redis:srem(bot_id..":"..msg.chat_id..":silent",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).helo,"md",true)  
end
if text == "الغاء كتم" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender_id.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
t = "*⤈︙ تم الغاء كتمه بنجاح .*"
redis:srem(bot_id..":"..msg.chat_id..":silent",Remsg.sender_id.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).helo,"md",true)  
end
if text == 'المكتومين' then
t = '\n*⤈︙ قائمه '..text..'  \nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ┉ ┉ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":silent") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ لا يوجد "..text:gsub('ال',"").." .*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.." .*"..k.." ⤈︙ *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.." .*"..k.." ⤈︙ * ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).yu,"md",true)  
end
if text == 'المقيدين' then
t = '\n*⤈︙ قائمه '..text..'  \nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ┉ ┉ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":restrict") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ لا يوجد "..text:gsub('ال',"").." .*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.." .*"..k.." ⤈︙ *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.." .*"..k.." ⤈︙ * ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).yu,"md",true)  
end
if text == 'المحظورين' then
t = '\n*⤈︙ قائمه '..text..'  \nٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ┉ ┉ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Ban") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ لا يوجد "..text:gsub('ال',"").." .*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.." .*"..k.." ⤈︙ *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.." .*"..k.." ⤈︙ * ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).yu,"md",true)  
end
if text == 'مسح المحظورين' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Ban") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
bot.setChatMemberStatus(msg.chat_id,v,'restricted',{1,1,1,1,1,1,1,1,1})
end
redis:del(bot_id..":"..msg.chat_id..":Ban") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").yu,"md",true)  
end
if text == 'مسح المطرودين' then
if not Owner(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المدير* ',"md",true)  
end
if msg.can_be_deleted_for_all_users == false then
return bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذراً البوت ليس ادمن في المجموعه يرجى رفعه وتفعيل الصلاحيات له *","md",true)  
end
if GetInfoBot(msg).BanUser == false then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ البوت ليس لديه صلاحيه حظر المستخدمين* ',"md",true)  
end
local Info_Members = bot.getSupergroupMembers(msg.chat_id, "Banned", "*", 0, 200)
x = 0
local y = false
local List_Members = Info_Members.members
for k, v in pairs(List_Members) do
UNBan_Bots = bot.setChatMemberStatus(msg.chat_id,v.member_id.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
if UNBan_Bots.luatele == "ok" then
x = x + 1
y = true
end
end
if y == true then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم الغاء الحظر عن  "..x.." عضو *").by,"md",true)
else
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙  لا يوجد مطرودين في البوت *").heloo,"md",true)
end
end
if text == 'مسح المحذوفين' or text == 'طرد المحذوفين' then
if not Owner(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المدير* ',"md",true)  
end
if msg.can_be_deleted_for_all_users == false then
return bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذراً البوت ليس ادمن في المجموعه يرجى رفعه وتفعيل الصلاحيات له  .*","md",true)  
end
if GetInfoBot(msg).BanUser == false then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ البوت ليس لديه صلاحيه حظر المستخدمين .* ',"md",true)  
end
local Info_Members = bot.searchChatMembers(msg.chat_id, "*", 200)
local List_Members = Info_Members.members
x = 0
local y = false
for k, v in pairs(List_Members) do
local UserInfo = bot.getUser(v.member_id.user_id)
if UserInfo.type.luatele == "userTypeDeleted" then
local userTypeDeleted = bot.setChatMemberStatus(msg.chat_id,v.member_id.user_id,'banned',0)
if userTypeDeleted.luatele == "ok" then
x = x + 1
y = true
end
end
end
if y == true then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم طرد "..x.." من الحسابات المحذوفه .*").by,"md",true)
else
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ لا توجد حسابات محذوفه هنا . *").yu,"md",true)
end
end
if text == 'مسح المكتومين' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":silent") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":silent") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").yu,"md",true)  
end
if text == 'مسح المقيدين' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":restrict") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
bot.setChatMemberStatus(msg.chat_id,v,'restricted',{1,1,1,1,1,1,1,1,1})
end
redis:del(bot_id..":"..msg.chat_id..":restrict") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").yu,"md",true)  
end
end
if programmer(msg)  then
if text and text:match('^كتم عام (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^كتم عام (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not Isrank(UserName,msg.chat_id) then
t = "*⤈︙ لا يمكنك كتم "..Get_Rank(UserName,msg.chat_id).." عام .*"
else
t = "*⤈︙ تم كتمه عام بنجاح .*"
redis:sadd(bot_id..":bot:silent",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^كتم عام @(%S+)$') then
local UserName = text:match('^كتم عام @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
if not Isrank(UserId_Info.id,msg.chat_id) then
t = "*⤈︙ لا يمكنك كتم "..Get_Rank(UserId_Info.id,msg.chat_id).." عام .*"
else
t = "*⤈︙ تم كتمه عام بنجاح .*"
redis:sadd(bot_id..":bot:silent",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)    
end
if text == "كتم عام" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender_id.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
if not Isrank(Remsg.sender_id.user_id,msg.chat_id) then
t = "*⤈︙ لا يمكنك كتم "..Get_Rank(Remsg.sender_id.user_id,msg.chat_id).." عام .*"
else
t = "*⤈︙ تم كتمه عام بنجاح .*"
redis:sadd(bot_id..":bot:silent",Remsg.sender_id.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender_id.user_id,t).i,"md",true)    
end
if text and text:match('^الغاء كتم عام (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء كتم عام (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*⤈︙ تم الغاء كتمه عام بنجاح .*"
redis:srem(bot_id..":bot:silent",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).helo,"md",true)    
end
if text and text:match('^الغاء كتم عام @(%S+)$') then
local UserName = text:match('^الغاء كتم عام @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
t = "*⤈︙ تم الغاء كتمه عام بنجاح .*"
redis:srem(bot_id..":bot:silent",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).helo,"md",true)  
end
if text == "الغاء كتم عام" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender_id.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
t = "*⤈︙ تم الغاء كتمه عام بنجاح .*"
redis:srem(bot_id..":bot:silent",Remsg.sender_id.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).helo,"md",true)  
end
if text == 'المكتومين عام' then
t = '\n*⤈︙ قائمه '..text..'  \n  ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*\n'
local Info_ = redis:smembers(bot_id..":bot:silent") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ لا يوجد "..text:gsub('ال',"").." .*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).yu,"md",true)  
end
if text == 'مسح المكتومين عام' then
local Info_ = redis:smembers(bot_id..":bot:silent") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم حذف"..text:gsub('مسح',"").." سابقا .*").yu,"md",true)
return false
end  
redis:del(bot_id..":bot:silent") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").yu,"md",true)  
end
if text and text:match('^حظر عام (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^حظر عام (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ البوت لا يمتلك صلاحيه حظر عام الاعضاء* ',"md",true)  
return false
end
if not Isrank(UserName,msg.chat_id) then
t = "*⤈︙ لايمكنك حظر "..Get_Rank(UserName,msg.chat_id).." عام .*"
else
t = "*⤈︙ تم حظره عام بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,UserName,'banned',0)
redis:sadd(bot_id..":bot:Ban",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^حظر عام @(%S+)$') then
local UserName = text:match('^حظر عام @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ البوت لا يمتلك صلاحيه حظر عام الاعضاء* ',"md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
if not Isrank(UserId_Info.id,msg.chat_id) then
t = "*⤈︙ لا يمكنك حظر "..Get_Rank(UserId_Info.id,msg.chat_id).." عام .*"
else
t = "*⤈︙ تم حظره عام بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'banned',0)
redis:sadd(bot_id..":bot:Ban",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)    
end
if text == "حظر عام" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender_id.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*⤈︙ البوت لا يمتلك صلاحيه حظر عام الاعضاء* ',"md",true)  
return false
end
if not Isrank(Remsg.sender_id.user_id,msg.chat_id) then
t = "*⤈︙ لا يمكنك حظر "..Get_Rank(Remsg.sender_id.user_id,msg.chat_id).." عام .*"
else
t = "*⤈︙ تم حظره عام بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,Remsg.sender_id.user_id,'banned',0)
redis:sadd(bot_id..":bot:Ban",Remsg.sender_id.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender_id.user_id,t).i,"md",true)    
end
if text and text:match('^الغاء حظر عام (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء حظر عام (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*⤈︙ تم الغاء حظره عام بنجاح .*"
redis:srem(bot_id..":bot:Ban",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).helo,"md",true)    
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^الغاء حظر عام @(%S+)$') then
local UserName = text:match('^الغاء حظر عام @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
t = "*⤈︙ تم الغاء حظره عام بنجاح .*"
redis:srem(bot_id..":bot:Ban",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).helo,"md",true)  
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text == "الغاء حظر عام" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender_id.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
t = "*⤈︙ تم الغاء حظره عام بنجاح .*"
redis:srem(bot_id..":bot:Ban",Remsg.sender_id.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender_id.user_id,t).helo,"md",true)    
bot.setChatMemberStatus(msg.chat_id,Remsg.sender_id.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text == 'المحظورين عام' then
t = '\n*⤈︙ قائمه '..text..'  \n  ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*\n'
local Info_ = redis:smembers(bot_id..":bot:Ban") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ لا يوجد "..text:gsub('ال',"").." .*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).yu,"md",true)  
end
if text == 'مسح المحظورين عام' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":bot:Ban") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
bot.setChatMemberStatus(msg.chat_id,v,'restricted',{1,1,1,1,1,1,1,1,1})
end
redis:del(bot_id..":bot:Ban") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").yu,"md",true)  
end
end
if text == "تقييد لرتبه" and programmer(msg) or text == "تقيد لرتبه" and programmer(msg) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'منشى اساسي'" ,data="changeofvalidity_"..msg.sender_id.user_id.."_5"}},
{{text = "'منشئ'" ,data="changeofvalidity_"..msg.sender_id.user_id.."_4"}},
{{text = "'مدير'" ,data="changeofvalidity_"..msg.sender_id.user_id.."_3"}},
{{text = "'ادمن'" ,data="changeofvalidity_"..msg.sender_id.user_id.."_2"}},
{{text = "'مميز'" ,data="changeofvalidity_"..msg.sender_id.user_id.."_1"}},
}
}
bot.sendText(msg.chat_id,msg.id,"*⤈︙ قم بأختيار الرتبه التي تريد تققيد محتوى لها .*","md", true, false, false, false, reply_markup)
end
if text == "تقييد صلاحيات" and msg.reply_to_message_id ~= 0 and Administrator(msg) then
Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
vr =Remsg.sender_id.user_id
if not Isrank(vr,msg.chat_id) then  
return bot.sendText(msg.chat_id,msg.id,"- يجب ان تكون رتبه الشخص ( منشئ اساسي ، منشئ ، مدير ،ادمن ،عضو مميز او عضو )؛","md")
end
local UserInfo = bot.getUser(Remsg.sender_id.user_id)
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الروابط'" ,data="donerout_"..msg.sender_id.user_id.."_Links_"..vr},{text =Gdone(msg.chat_id,vr,"Links") ,data="donerout_"..msg.sender_id.user_id.."_Links_"..vr}},
{{text = "'التوجيه'" ,data="donerout_"..msg.sender_id.user_id.."_forwardinfo_"..vr},{text =Gdone(msg.chat_id,vr,"forwardinfo"),data="donerout_"..msg.sender_id.user_id.."_forwardinfo_"..vr}},
{{text = "'التعديل'" ,data="donerout_"..msg.sender_id.user_id.."_Edited_"..vr},{text =Gdone(msg.chat_id,vr,"Edited"),data="donerout_"..msg.sender_id.user_id.."_Edited_"..vr}},
{{text = "'الجهات'" ,data="donerout_"..msg.sender_id.user_id.."_messageContact_"..vr},{text =Gdone(msg.chat_id,vr,"messageContact"),data="donerout_"..msg.sender_id.user_id.."_messageContact_"..vr}},
{{text = "'الصور'" ,data="donerout_"..msg.sender_id.user_id.."_messagePhoto_"..vr},{text =Gdone(msg.chat_id,vr,"messagePhoto"),data="donerout_"..msg.sender_id.user_id.."_messagePhoto_"..vr}},
{{text = "'الفيديو'" ,data="donerout_"..msg.sender_id.user_id.."_messageVideo_"..vr},{text =Gdone(msg.chat_id,vr,"messageVideo"),data="donerout_"..msg.sender_id.user_id.."_messageVideo_"..vr}},
{{text = "'المتحركات'" ,data="donerout_"..msg.sender_id.user_id.."_messageAnimation_"..vr},{text =Gdone(msg.chat_id,vr,"messageAnimation"),data="donerout_"..msg.sender_id.user_id.."_messageAnimation_"..vr}},
{{text = "'الملصقات'" ,data="donerout_"..msg.sender_id.user_id.."_messageSticker_"..vr},{text =Gdone(msg.chat_id,vr,"messageSticker"),data="donerout_"..msg.sender_id.user_id.."_messageSticker_"..vr}},
{{text = "'الملفات'" ,data="donerout_"..msg.sender_id.user_id.."_messageDocument_"..vr},{text =Gdone(msg.chat_id,vr,"messageDocument"),data="donerout_"..msg.sender_id.user_id.."_messageDocument_"..vr}},
{{text = "‹ اخفاء ›" ,data="Rdel_"..msg.sender_id.user_id.."_Rdel"}},
}
}
bot.sendText(msg.chat_id,msg.id,"- قم باختيار ما تريد تقييده عن ( "..Reply_Status(UserInfo.id,"").user.."؛)","md", true, false, false, false, reply_markup)
end
if text and text:match('^تقييد صلاحيات (%d+)$') and msg.reply_to_message_id == 0 and Administrator(msg) then
local UserName = text:match('^تقييد صلاحيات (%d+)$')
vr =UserName
if not Isrank(vr,msg.chat_id) then  
return bot.sendText(msg.chat_id,msg.id,"- يجب ان تكون رتبه الشخص ( منشئ اساسي ، منشئ ، مدير ،ادمن ،عضو مميز او عضو )؛","md")
end
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ الایدي خطأ .*","md",true)  
return false
end
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الروابط'" ,data="donerout_"..msg.sender_id.user_id.."_Links_"..vr},{text =Gdone(msg.chat_id,vr,"Links") ,data="donerout_"..msg.sender_id.user_id.."_Links_"..vr}},
{{text = "'التوجيه'" ,data="donerout_"..msg.sender_id.user_id.."_forwardinfo_"..vr},{text =Gdone(msg.chat_id,vr,"forwardinfo"),data="donerout_"..msg.sender_id.user_id.."_forwardinfo_"..vr}},
{{text = "'التعديل'" ,data="donerout_"..msg.sender_id.user_id.."_Edited_"..vr},{text =Gdone(msg.chat_id,vr,"Edited"),data="donerout_"..msg.sender_id.user_id.."_Edited_"..vr}},
{{text = "'الجهات'" ,data="donerout_"..msg.sender_id.user_id.."_messageContact_"..vr},{text =Gdone(msg.chat_id,vr,"messageContact"),data="donerout_"..msg.sender_id.user_id.."_messageContact_"..vr}},
{{text = "'الصور'" ,data="donerout_"..msg.sender_id.user_id.."_messagePhoto_"..vr},{text =Gdone(msg.chat_id,vr,"messagePhoto"),data="donerout_"..msg.sender_id.user_id.."_messagePhoto_"..vr}},
{{text = "'الفيديو'" ,data="donerout_"..msg.sender_id.user_id.."_messageVideo_"..vr},{text =Gdone(msg.chat_id,vr,"messageVideo"),data="donerout_"..msg.sender_id.user_id.."_messageVideo_"..vr}},
{{text = "'المتحركات'" ,data="donerout_"..msg.sender_id.user_id.."_messageAnimation_"..vr},{text =Gdone(msg.chat_id,vr,"messageAnimation"),data="donerout_"..msg.sender_id.user_id.."_messageAnimation_"..vr}},
{{text = "'الملصقات'" ,data="donerout_"..msg.sender_id.user_id.."_messageSticker_"..vr},{text =Gdone(msg.chat_id,vr,"messageSticker"),data="donerout_"..msg.sender_id.user_id.."_messageSticker_"..vr}},
{{text = "'الملفات'" ,data="donerout_"..msg.sender_id.user_id.."_messageDocument_"..vr},{text =Gdone(msg.chat_id,vr,"messageDocument"),data="donerout_"..msg.sender_id.user_id.."_messageDocument_"..vr}},
{{text = "‹ اخفاء ›" ,data="Rdel_"..msg.sender_id.user_id.."_Rdel"}},
}
}
bot.sendText(msg.chat_id,msg.id,"- قم باختيار ما تريد تقييده عن ( "..Reply_Status(UserInfo.id,"").user.."؛)","md", true, false, false, false, reply_markup)
end
if text and text:match('^تقييد صلاحيات @(%S+)$') and msg.reply_to_message_id == 0 and Administrator(msg) then
local UserName = text:match('^تقييد صلاحيات @(%S+)$')
vr =UserName
if not Isrank(vr,msg.chat_id) then  
return bot.sendText(msg.chat_id,msg.id,"- يجب ان تكون رتبه الشخص ( منشئ اساسي ، منشئ ، مدير ،ادمن ،عضو مميز او عضو )؛","md")
end
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر لقناه او مجموعه تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الروابط'" ,data="donerout_"..msg.sender_id.user_id.."_Links_"..vr},{text =Gdone(msg.chat_id,vr,"Links") ,data="donerout_"..msg.sender_id.user_id.."_Links_"..vr}},
{{text = "'التوجيه'" ,data="donerout_"..msg.sender_id.user_id.."_forwardinfo_"..vr},{text =Gdone(msg.chat_id,vr,"forwardinfo"),data="donerout_"..msg.sender_id.user_id.."_forwardinfo_"..vr}},
{{text = "'التعديل'" ,data="donerout_"..msg.sender_id.user_id.."_Edited_"..vr},{text =Gdone(msg.chat_id,vr,"Edited"),data="donerout_"..msg.sender_id.user_id.."_Edited_"..vr}},
{{text = "'الجهات'" ,data="donerout_"..msg.sender_id.user_id.."_messageContact_"..vr},{text =Gdone(msg.chat_id,vr,"messageContact"),data="donerout_"..msg.sender_id.user_id.."_messageContact_"..vr}},
{{text = "'الصور'" ,data="donerout_"..msg.sender_id.user_id.."_messagePhoto_"..vr},{text =Gdone(msg.chat_id,vr,"messagePhoto"),data="donerout_"..msg.sender_id.user_id.."_messagePhoto_"..vr}},
{{text = "'الفيديو'" ,data="donerout_"..msg.sender_id.user_id.."_messageVideo_"..vr},{text =Gdone(msg.chat_id,vr,"messageVideo"),data="donerout_"..msg.sender_id.user_id.."_messageVideo_"..vr}},
{{text = "'المتحركات'" ,data="donerout_"..msg.sender_id.user_id.."_messageAnimation_"..vr},{text =Gdone(msg.chat_id,vr,"messageAnimation"),data="donerout_"..msg.sender_id.user_id.."_messageAnimation_"..vr}},
{{text = "'الملصقات'" ,data="donerout_"..msg.sender_id.user_id.."_messageSticker_"..vr},{text =Gdone(msg.chat_id,vr,"messageSticker"),data="donerout_"..msg.sender_id.user_id.."_messageSticker_"..vr}},
{{text = "'الملفات'" ,data="donerout_"..msg.sender_id.user_id.."_messageDocument_"..vr},{text =Gdone(msg.chat_id,vr,"messageDocument"),data="donerout_"..msg.sender_id.user_id.."_messageDocument_"..vr}},
{{text = "‹ اخفاء ›" ,data="Rdel_"..msg.sender_id.user_id.."_Rdel"}},
}
}
bot.sendText(msg.chat_id,msg.id,"⤈︙ قم باختيار ما تريد تقييده عن ( "..Reply_Status(UserInfo.id,"").user.."؛)","md", true, false, false, false, reply_markup)
end
if text == "تحكم" and msg.reply_to_message_id ~= 0 and Administrator(msg) then
Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender_id.user_id)
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text ="قائمه 'الرفع و التنزيل'",data="control_"..msg.sender_id.user_id.."_"..UserInfo.id.."_1"}},
{{text ="قائمه 'العقوبات'",data="control_"..msg.sender_id.user_id.."_"..UserInfo.id.."_2"}},
{{text = "كشف 'المعلومات'" ,data="control_"..msg.sender_id.user_id.."_"..UserInfo.id.."_3"}},
}
}
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اختر الامر المناسب*","md", true, false, false, false, reply_markup)
end
if text and text:match('^تحكم (%d+)$') and msg.reply_to_message_id == 0 and Administrator(msg) then
local UserName = text:match('^تحكم (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ الایدي خطأ .*","md",true)  
return false
end
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text ="قائمه 'الرفع و التنزيل'",data="control_"..msg.sender_id.user_id.."_"..UserInfo.id.."_1"}},
{{text ="قائمه 'العقوبات'",data="control_"..msg.sender_id.user_id.."_"..UserInfo.id.."_2"}},
{{text = "كشف 'المعلومات'" ,data="control_"..msg.sender_id.user_id.."_"..UserInfo.id.."_3"}},
}
}
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اختر الامر المناسب .*","md", true, false, false, false, reply_markup)
end
if text and text:match('^تحكم @(%S+)$') and msg.reply_to_message_id == 0 and Administrator(msg) then
local UserName = text:match('^تحكم @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر لقناه او مجموعه تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text ="قائمه 'الرفع و التنزيل'",data="control_"..msg.sender_id.user_id.."_"..UserId_Info.id.."_1"}},
{{text ="قائمه 'العقوبات'",data="control_"..msg.sender_id.user_id.."_"..UserId_Info.id.."_2"}},
{{text = "كشف 'المعلومات'" ,data="control_"..msg.sender_id.user_id.."_"..UserId_Info.id.."_3"}},
}
}
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اختر الامر المناسب .*","md", true, false, false, false, reply_markup)
end

----------------------------------------------------------------------------------------------------
if not redis:get(bot_id..":"..msg.chat_id..":settings:all") then
if text == '@all' and BasicConstructor(msg) then
if redis:get(bot_id..':'..msg.chat_id..':all') then
return bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم عمل تاك في المجموعه قبل قليل انتظر من فضلك .*","md",true) 
end
local Info = bot.searchChatMembers(msg.chat_id, "*", 200)
local members = Info.members
if #members <= 9 then
return bot.sendText(msg.chat_id,msg.id,"*⤈︙ لا يوجد عدد كافي من الاعضاء .*","md",true) 
end
redis:setex(bot_id..':'..msg.chat_id..':all',300,true)
x = 0
tags = 0
for k, v in pairs(members) do
local UserInfo = bot.getUser(v.member_id.user_id)
if x == 10 or x == tags or k == 0 then
tags = x + 10
t = "#all"
end
x = x + 1
tagname = UserInfo.first_name.."ْ"
tagname = tagname:gsub('"',"")
tagname = tagname:gsub('"',"")
tagname = tagname:gsub("`","")
tagname = tagname:gsub("*","") 
tagname = tagname:gsub("_","")
tagname = tagname:gsub("]","")
tagname = tagname:gsub("[[]","")
t = t.." ~ ["..tagname.."](tg://user?id="..v.member_id.user_id..")"
if x == 10 or x == tags or k == 0 then
local Text = t:gsub('#all,','#all\n')
bot.sendText(msg.chat_id,0,Text,"md",true)  
end
end
end
if text and text:match("^@all (.*)$") and BasicConstructor(msg) then
if text:match("^@all (.*)$") ~= nil and text:match("^@all (.*)$") ~= "" then
TextMsg = text:match("^@all (.*)$")
if redis:get(bot_id..':'..msg.chat_id..':all') then
return bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم عمل تاك في المجموعه قبل قليل انتظر من فضلك .*","md",true) 
end
local Info = bot.searchChatMembers(msg.chat_id, "*", 200)
local members = Info.members
if #members <= 9 then
return bot.sendText(msg.chat_id,msg.id,"*⤈︙ لا يوجد عدد كافي من الاعضاء .*","md",true) 
end
redis:setex(bot_id..':'..msg.chat_id..':all',300,true)
x = 0
tags = 0
for k, v in pairs(members) do
local UserInfo = bot.getUser(v.member_id.user_id)
if x == 10 or x == tags or k == 0 then
tags = x + 10
t = "#all"
end
x = x + 1
tagname = UserInfo.first_name.."ْ"
tagname = tagname:gsub('"',"")
tagname = tagname:gsub('"',"")
tagname = tagname:gsub("`","")
tagname = tagname:gsub("*","") 
tagname = tagname:gsub("_","")
tagname = tagname:gsub("]","")
tagname = tagname:gsub("[[]","")
t = t.." ~ ["..tagname.."](tg://user?id="..v.member_id.user_id..")"
if x == 10 or x == tags or k == 0 then
local Text = t:gsub('#all,','#all\n')
TextMsg = TextMsg
TextMsg = TextMsg:gsub('"',"")
TextMsg = TextMsg:gsub('"',"")
TextMsg = TextMsg:gsub("`","")
TextMsg = TextMsg:gsub("*","") 
TextMsg = TextMsg:gsub("_","")
TextMsg = TextMsg:gsub("]","")
TextMsg = TextMsg:gsub("[[]","")
bot.sendText(msg.chat_id,0,TextMsg.."\n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n"..Text,"md",true)  
end
end
end
end
end
--
if msg and msg.content then
if text == 'تنزيل جميع الرتب' and Creator(msg) then   
redis:del(bot_id..":"..msg.chat_id..":Status:BasicConstructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Constructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Owner")
redis:del(bot_id..":"..msg.chat_id..":Status:Administrator")
redis:del(bot_id..":"..msg.chat_id..":Status:Vips")
bot.sendText(msg.chat_id,msg.id,"*⤈︙ تم "..text.." *","md", true)
end
if msg.content.luatele == "messageSticker" or msg.content.luatele == "messageUnsupported" or msg.content.luatele == "messageContact" or msg.content.luatele == "messageVideoNote" or msg.content.luatele == "messageDocument" or msg.content.luatele == "messageVideo" or msg.content.luatele == "messageAnimation" or msg.content.luatele == "messagePhoto" then
redis:sadd(bot_id..":"..msg.chat_id..":mediaAude:ids",msg.id)  
end
if redis:get(bot_id..":"..msg.chat_id..":settings:mediaAude") then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
local gmedia = redis:scard(bot_id..":"..msg.chat_id..":mediaAude:ids")  
if gmedia >= tonumber(redis:get(bot_id..":mediaAude:utdl"..msg.chat_id) or 200) then
local liste = redis:smembers(bot_id..":"..msg.chat_id..":mediaAude:ids")
for k,v in pairs(liste) do
local Mesge = v
if Mesge then
t = "*⤈︙ تم مسح "..k.." من الوسائط تلقائيا\n⤈︙ يمكنك تعطيل الميزه بستخدام الامر ( تعطيل المسح التلقائي ) .*"
bot.deleteMessages(msg.chat_id,{[1]= Mesge})
end
end
bot.sendText(msg.chat_id,msg.id,t,"md",true, false, false, false, reply_markup)
redis:del(bot_id..":"..msg.chat_id..":mediaAude:ids")
end
end
end
if text == 'تفعيل المكناسه' and BasicConstructor(msg) then   
if redis:get(bot_id..":"..msg.chat_id..":settings:clener") then
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
redis:set(bot_id..":"..msg.chat_id..":settings:clener",true)  
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل المكناسه' and BasicConstructor(msg) then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:clener") then
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:clener")  
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل المسح التلقائي' and BasicConstructor(msg) then   
if not developer(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ الامر يخص المطور وما فوق .* ',"md",true)  
end
if redis:get(bot_id..":"..msg.chat_id..":settings:mediaAude") then
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
redis:set(bot_id..":"..msg.chat_id..":settings:mediaAude",true)  
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل المسح التلقائي' and BasicConstructor(msg) then  
if not developer(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ الامر يخص المطور وما فوق .* ',"md",true)  
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:mediaAude") then
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:mediaAude")  
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل all' and Creator(msg) then   
if redis:get(bot_id..":"..msg.chat_id..":settings:all") then
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:all")  
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل all' and Creator(msg) then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:all") then
redis:set(bot_id..":"..msg.chat_id..":settings:all",true)  
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if BasicConstructor(msg) then
if text == 'تفعيل الرفع' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:up") then
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:up")  
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الرفع' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:up") then
redis:set(bot_id..":"..msg.chat_id..":settings:up",true)  
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل الكتم' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:ktm")  
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙⤈︙ تم "..text.." من قبلً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الكتم' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
redis:set(bot_id..":"..msg.chat_id..":settings:ktm",true)  
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل الحظر' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:bn")  
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الحظر' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
redis:set(bot_id..":"..msg.chat_id..":settings:bn",true)  
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل الطرد' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:kik")  
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الطرد' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
redis:set(bot_id..":"..msg.chat_id..":settings:kik",true)  
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
end
--
if Owner(msg) then
if text and text:match("^وضع عدد المسح (.*)$") then
local StatusMember = bot.getChatMember(msg.chat_id,msg.sender_id.user_id).status.luatele
if not developer(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ الامر يخص المطور وما فوق .* ',"md",true)  
end
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
local Teext = text:match("^وضع عدد المسح (.*)$") 
if Teext and Teext:match('%d+') then
t = "*⤈︙ تم تعيين  ( "..Teext.." ) عدد المسح التلقائي .*"
redis:set(bot_id..":mediaAude:utdl"..msg.chat_id,Teext)
else
t = "⤈︙ عذرا يجب كتابه ( وضع عدد المسح + رقم )"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).yu,"md",true, false, false, false, reply_markup)
end
if text == ("عدد الميديا") or text == ("الميديا") then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ اخفاء ›',data ="https://t.me/delAmr"}},
}
}
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ عدد الميديا هو :  "..redis:scard(bot_id..":"..msg.chat_id..":mediaAude:ids").." .*").yu,"md",true, false, false, false, reply_markup)
end
--
if text == 'تفعيل اطردني' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:kickme") then
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:kickme")  
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل اطردني' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:kickme") then
redis:set(bot_id..":"..msg.chat_id..":settings:kickme",true)  
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل البايو' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:GetBio") then
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:GetBio")  
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل البايو' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:GetBio") then
redis:set(bot_id..":"..msg.chat_id..":settings:GetBio",true)  
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل ردود البوت' and Creator(msg) then         
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":Rdodbot")  
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل ردود البوت' and Creator(msg) then        
if not redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
redis:set(bot_id..":"..msg.chat_id..":Rdodbot",true)  
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل الرابط' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المشرفين فقط .* ',"md",true)  
end
redis:set(bot_id.."Status:Link"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تفعيل الرابط بنجاح .*").by,"md",true)
end
if text == 'تعطيل الرابط' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المشرفين فقط .* ',"md",true)  
end
redis:del(bot_id.."Status:Link"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم تعطيل الرابط بنجاح .*").by,"md",true)
end
--
if text == 'تفعيل الترحيب' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:Welcome") then
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:Welcome")  
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الترحيب' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:Welcome") then
redis:set(bot_id..":"..msg.chat_id..":settings:Welcome",true)  
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل التنظيف' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:delmsg") then
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:delmsg")  
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل التنظيف' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:delmsg") then
redis:set(bot_id..":"..msg.chat_id..":settings:delmsg",true)  
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل الايدي' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:id") then
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:id")  
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الايدي' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:id") then
redis:set(bot_id..":"..msg.chat_id..":settings:id",true)  
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل الايدي بالصوره' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:id:ph") then
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:id:ph")  
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الايدي بالصوره' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:id:ph") then
redis:set(bot_id..":"..msg.chat_id..":settings:id:ph",true)  
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل ردود المدير' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:Reply") then
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:Reply")  
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل ردود المدير' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:Reply") then
redis:set(bot_id..":"..msg.chat_id..":settings:Reply",true)  
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل الالعاب المتطوره' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:gameVip") then
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:gameVip")  
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الالعاب المتطوره' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:gameVip") then
redis:set(bot_id..":"..msg.chat_id..":settings:gameVip",true)  
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
----------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
if text and text:match('^تنزيل الكل (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^تنزيل الكل (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if Get_Rank(UserName,msg.chat_id)== "العضو" then
tt = "لا يمتلك رتبه بالفعل"
else
tt = "تم تنزيله من جميع الرتب بنجاح"
end
if devB(msg.sender_id.user_id) then
redis:srem(bot_id..":Status:Basic",UserName)
redis:srem(bot_id..":Status:programmer",UserName)
redis:srem(bot_id..":Status:developer",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Basic(msg) then
redis:srem(bot_id..":Status:programmer",UserName)
redis:srem(bot_id..":Status:developer",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif programmer(msg) then
redis:srem(bot_id..":Status:developer",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif developer(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Creator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Creator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif BasicConstructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Constructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Owner(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Administrator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Vips(msg) then
return false
else
return false
end
if bot.getChatMember(msg.chat_id,UserName).status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*⤈︙ "..tt.." .*").helo,"md",true)  
return false
end
if text and text:match('^تنزيل الكل @(%S+)$') then
local UserName = text:match('^تنزيل الكل @(%S+)$') 
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
if Get_Rank(UserId_Info.id,msg.chat_id)== "العضو" then
tt = "لا يمتلك رتبه بالفعل"
else
tt = "تم تنزيله من جميع الرتب بنجاح"
end
if devB(msg.sender_id.user_id) then
redis:srem(bot_id..":Status:Basic",UserInfo.id)
redis:srem(bot_id..":Status:programmer",UserInfo.id)
redis:srem(bot_id..":Status:developer",UserInfo.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserInfo.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserInfo.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserInfo.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserInfo.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserInfo.id)
elseif Basic(msg) then
redis:srem(bot_id..":Status:programmer",UserInfo.id)
redis:srem(bot_id..":Status:developer",UserInfo.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserInfo.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserInfo.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserInfo.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserInfo.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserInfo.id)
elseif programmer(msg) then
redis:srem(bot_id..":Status:developer",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif developer(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Creator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Creator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif BasicConstructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Constructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Owner(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Administrator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Vips(msg) then
return false
else
return false
end
if bot.getChatMember(msg.chat_id,UserId_Info.id).status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*⤈︙ "..tt.." .*").helo,"md",true)  
return false
end
if text == "تنزيل الكل" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender_id.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
if Get_Rank(Remsg.sender_id.user_id,msg.chat_id)== "العضو" then
tt = "لا يمتلك رتبه بالفعل"
else
tt = "تم تنزيله من جميع الرتب بنجاح"
end
if devB(msg.sender_id.user_id) then
redis:srem(bot_id..":Status:Basic",Remsg.sender_id.user_id)
redis:srem(bot_id..":Status:programmer",Remsg.sender_id.user_id)
redis:srem(bot_id..":Status:developer",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender_id.user_id)
elseif Basic(msg) then
redis:srem(bot_id..":Status:programmer",Remsg.sender_id.user_id)
redis:srem(bot_id..":Status:developer",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender_id.user_id)
elseif programmer(msg) then
redis:srem(bot_id..":Status:developer",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender_id.user_id)
elseif developer(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Creator",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender_id.user_id)
elseif Creator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender_id.user_id)
elseif BasicConstructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender_id.user_id)
elseif Constructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender_id.user_id)
elseif Owner(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender_id.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender_id.user_id)
elseif Administrator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender_id.user_id)
elseif Vips(msg) then
return false
else
return false
end
if bot.getChatMember(msg.chat_id,Remsg.sender_id.user_id).status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",Remsg.sender_id.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender_id.user_id,"*⤈︙ "..tt.." .*").helo,"md",true)  
return false
end
if text and text:match('^رفع (.*) (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local Usertext = {text:match('^رفع (.*) (%d+)$')}
local TextMsg = Usertext[1]
local UserName = Usertext[2]
if msg.content.text then 
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if TextMsg == 'مطور اساسي' then
srt = "Basic"
srt1 = ":"
elseif TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:Up") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ الرفع معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
if devB(msg.sender_id.user_id) then
if redis:sismember(bot_id..srt1.."Status:"..srt,UserName) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*⤈︙ تم رفعه سابقا .*").i,"md",true)  
return false
end
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif Basic(msg) then
if redis:sismember(bot_id..srt1.."Status:"..srt,UserName) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*⤈︙ تم رفعه سابقا .*").i,"md",true)  
return false
end
if TextMsg == 'مطور ثانوي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مطور' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*⤈︙  تم رفعه "..TextMsg.." بنجاح .*").helo,"md",true)  
return false
end
end
if text and text:match('^رفع (.*) @(%S+)$') and tonumber(msg.reply_to_message_id) == 0 then
local Usertext = {text:match('^رفع (.*) @(%S+)$')}
local TextMsg = Usertext[1]
local UserName = Usertext[2]
if msg.content.text then 
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر لقناه او كروب تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if TextMsg == 'مطور اساسي' then
srt = "Basic"
srt1 = ":"
elseif TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
local UserInfo = bot.getUser(UserId_Info.id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذراً تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:Up") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ الرفع معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
local UserInfo = bot.getUser(UserInfo.id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.TD == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
if devB(msg.sender_id.user_id) then
if redis:sismember(bot_id..srt1.."Status:"..srt,UserInfo.id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender_id.user_id,"*⤈︙  تم رفعه "..TextMsg.." بنجاح .*").helo,"md",true)  
return false
end
redis:sadd(bot_id..srt1.."Status:"..srt,UserInfo.id)
elseif Basic(msg) then
if redis:sismember(bot_id..srt1.."Status:"..srt,UserInfo.id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender_id.user_id,"*⤈︙  تم رفعه "..TextMsg.." بنجاح .*").helo,"md",true)  
return false
end
if TextMsg == 'مطور ثانوي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserInfo.id)
elseif TextMsg == 'مطور' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserInfo.id)
elseif TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserInfo.id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserInfo.id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserInfo.id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserInfo.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserInfo.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserInfo.id)
else
return false
end
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*⤈︙  تم رفعه "..TextMsg.." بنجاح .*").helo,"md",true)  
return false
end
end
if text and text:match("^رفع (.*)$") and tonumber(msg.reply_to_message_id) ~= 0 then
local TextMsg = text:match("^رفع (.*)$")
if msg.content.text then 
if TextMsg == 'مطور اساسي' then
srt = "Basic"
srt1 = ":"
elseif TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender_id.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.TD == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:Up") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ الرفع معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
if devB(msg.sender_id.user_id) then
if redis:sismember(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender_id.user_id,"*⤈︙ تم رفعه سابقا .*").i,"md",true)  
return false
end
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif Basic(msg) then
if redis:sismember(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender_id.user_id,"*⤈︙ تم رفعه سابقا .*").i,"md",true)  
return false
end
if TextMsg == 'مطور ثانوي' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مطور' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
else
return false
end
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender_id.user_id,"*⤈︙  تم رفعه "..TextMsg.." بنجاح .*").helo,"md",true)  
return false
end
end
if text and text:match('^تنزيل (.*) (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local Usertext = {text:match('^تنزيل (.*) (%d+)$')}
local TextMsg = Usertext[1]
local UserName = Usertext[2]
if msg.content.text then 
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if TextMsg == 'مطور اساسي' then
srt = "Basic"
srt1 = ":"
elseif TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
if not redis:sismember(bot_id..srt1.."Status:"..srt,UserName) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*⤈︙ لا يمتلك رتبه "..TextMsg.." لتقوم في تنزيله .*").helo,"md",true)  
return false
end
if devB(msg.sender_id.user_id) then
if not redis:sismember(bot_id..srt1.."Status:"..srt,UserName) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*⤈︙ لا يمتلك رتبه "..TextMsg.." لتقوم في تنزيله .*").helo,"md",true)  
return false
end
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif Basic(msg) then
if not redis:sismember(bot_id..srt1.."Status:"..srt,UserName) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*⤈︙ لا يمتلك رتبه "..TextMsg.." لتقوم في تنزيله .*").helo,"md",true)  
return false
end
if TextMsg == 'مطور ثانوي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*⤈︙  تم تنزيله من رتبه "..TextMsg.." بنجاح .*").helo,"md",true)  
return false
end
end
if text and text:match('^تنزيل (.*) @(%S+)$') and tonumber(msg.reply_to_message_id) == 0 then
local Usertext = {text:match('^تنزيل (.*) @(%S+)$')}
local TextMsg = Usertext[1]
local UserName = Usertext[2]
if msg.content.text then 
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ اليوزر لقناه او كروب تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if TextMsg == 'مطور اساسي' then
srt = "Basic"
srt1 = ":"
elseif TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
local UserInfo = bot.getUser(UserId_Info.id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذراً تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if not redis:sismember(bot_id..srt1.."Status:"..srt,UserId_Info.id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*⤈︙  لا يمتلك رتبه "..TextMsg.." لتقوم في تنزيله .*").helo,"md",true)  
return false
end
if devB(msg.sender_id.user_id) then
if not redis:sismember(bot_id..srt1.."Status:"..srt,UserInfo.id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserInfo.id,"*⤈︙ لا يمتلك رتبه بالفعل  .*").yu,"md",true)  
return false
end
redis:srem(bot_id..srt1.."Status:"..srt,UserInfo.id)
elseif Basic(msg) then
if not redis:sismember(bot_id..srt1.."Status:"..srt,UserInfo.id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserInfo.id,"*⤈︙ لا يمتلك رتبه بالفعل  .*").yu,"md",true)  
return false
end
if TextMsg == 'مطور ثانوي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserInfo.id)
elseif TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,UserInfo.id)
elseif TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,UserInfo.id)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserInfo.id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserInfo.id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserInfo.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserInfo.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserInfo.id)
else
return false
end
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*⤈︙  تم تنزيله من رتبه "..TextMsg.." بنجاح .*").helo,"md",true)  
return false
end
end
if text and text:match("^تنزيل (.*)$") and tonumber(msg.reply_to_message_id) ~= 0 then
local TextMsg = text:match("^تنزيل (.*)$")
if msg.content.text then 
if TextMsg == 'مطور اساسي' then
srt = "Basic"
srt1 = ":"
elseif TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender_id.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذراً تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⤈︙ عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if not redis:sismember(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender_id.user_id,"*⤈︙  لا يمتلك رتبه "..TextMsg.." لتقوم في تنزيله .*").helo,"md",true)  
return false
end
if devB(msg.sender_id.user_id) then
if not redis:sismember(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender_id.user_id,"*⤈︙ لا يمتلك رتبه بالفعل  .*").yu,"md",true)  
return false
end
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif Basic(msg) then
if not redis:sismember(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender_id.user_id,"*⤈︙ لا يمتلك رتبه بالفعل  .*").yu,"md",true)  
return false
end
if TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
else
return false
end
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender_id.user_id)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender_id.user_id,"*⤈︙ تم تنزيله من رتبه "..TextMsg.." بنجاح .*").helo,"md",true)  
return false
end
end
----------------------------------------------------------------------------------------------------
if Administrator(msg) then
if text == 'الاساسيين' or text == 'المطورين الاساسيين' then
if not devB(msg.sender_id.user_id) then 
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ الامر يخص المطور الاساسي فقط .* ',"md",true)  
end
t = '\n*⤈︙ قائمه '..text..'  \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉  *\n'
local Info_ = redis:smembers(bot_id..":Status:Basic") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ لا يوجد "..text:gsub('ال',"").." في المجموعه .*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." : *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." : * ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).yu, 'md', true)
end
if text == 'الثانويين' or text == 'المطورين الثانويين' then
if not devB(msg.sender_id.user_id) then 
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ الامر يخص المطور الاساسي فقط .* ',"md",true)  
end
t = '\n*⤈︙ قائمه '..text..'  \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉  *\n'
local Info_ = redis:smembers(bot_id..":Status:programmer") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ لا يوجد "..text:gsub('ال',"").." في المجموعه .*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." : *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." : * ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).yu, 'md', true)
end
if text == 'المطورين' then
if not devB(msg.sender_id.user_id) then 
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ الامر يخص المطور الاساسي فقط .* ',"md",true)  
end
t = '\n*⤈︙ قائمه '..text..'  \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉  *\n'
local Info_ = redis:smembers(bot_id..":Status:developer") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ لا يوجد "..text:gsub('ال',"").." في المجموعه .*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." : *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." : * ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).yu, 'md', true)
end
if text == 'المالكين' then
t = '\n*⤈︙ قائمه '..text..'  \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Creator") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ لا يوجد المالكين*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." : *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." : * ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).yu,"md",true)  
end
if text == 'المنشئين الاساسيين' then
t = '\n*⤈︙ قائمه '..text..'  \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:BasicConstructor") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ لا يوجد "..text:gsub('ال',"").." في المجموعه .*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." : *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." : * ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).yu,"md",true)  
end
if text == 'المنشئين' then
t = '\n*⤈︙ قائمه '..text..'  \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Constructor") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ لا يوجد "..text:gsub('ال',"").." في المجموعه .*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." : *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." : * ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).yu,"md",true)  
end
if text == 'المدراء' then
t = '\n*⤈︙ قائمه '..text..'  \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Owner") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ لا يوجد "..text:gsub('ال',"").." في المجموعه .*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." : *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." : * ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).yu,"md",true)  
end
if text == 'الادمنيه' then
t = '\n*⤈︙ قائمه '..text..'  \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Administrator") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ لا يوجد "..text:gsub('ال',"").." في المجموعه .*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." : *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." : * ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).yu,"md",true)  
end
if text == 'المميزين' then
t = '\n*⤈︙ قائمه '..text..'  \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Vips") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ لا يوجد "..text:gsub('ال',"").." في المجموعه .*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." : *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." : * ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,t).yu,"md",true)  
end
----------------------------------------------------------------------------------------------------
end
if text == 'مسح الاساسيين' or text == 'مسح المطورين الاساسيين' and devB(msg.sender_id.user_id) then
local Info_ = redis:smembers(bot_id..":Status:Basic") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
redis:del(bot_id..":Status:Basic") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح*").yu,"md",true)  
end
if text == 'مسح الثانويين' or text == 'مسح المطورين الثانويين' and Basic(msg) then
local Info_ = redis:smembers(bot_id..":Status:programmer") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
redis:del(bot_id..":Status:programmer") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").yu,"md",true)  
end
if text == 'مسح المطورين' and programmer(msg) then
if not devB(msg.sender_id.user_id) then 
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ الامر يخص المطور الاساسي فقط .* ',"md",true)  
end
local Info_ = redis:smembers(bot_id..":Status:developer") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
redis:del(bot_id..":Status:developer") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").yu,"md",true)  
end
if text == 'مسح المالكين' and developer(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Creator") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Creator") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").yu,"md",true)  
end
if text == 'مسح المنشئين الاساسيين' and Creator(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:BasicConstructor") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:BasicConstructor") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").yu,"md",true)  
end
if text == 'مسح المنشئين' and BasicConstructor(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Constructor") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Constructor") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").yu,"md",true)  
end
if text == 'مسح المدراء' and Constructor(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Owner") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Owner") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").yu,"md",true)  
end
if text == 'مسح الادمنيه' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Administrator") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Administrator") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").yu,"md",true)  
end
if text == 'مسح المميزين' and Administrator(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Vips") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Vips") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ تم "..text.." بنجاح .*").yu,"md",true)  
end
----------------------------------------------------------------------------------------------------
if text and not redis:get(bot_id..":"..msg.chat_id..":settings:Reply") then
if text and redis:sismember(bot_id..'List:array'..msg.chat_id,text) then
local list = redis:smembers(bot_id.."Add:Rd:array:Text"..text..msg.chat_id)
return bot.sendText(msg.chat_id,msg.id,"["..list[math.random(#list)].."]","md",true)
end  
if not redis:sismember(bot_id..'Spam:Group'..msg.sender_id.user_id,text) then
local Text = redis:get(bot_id.."Rp:content:Text"..msg.chat_id..":"..text)
local VoiceNote = redis:get(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..text) 
local photo = redis:get(bot_id.."Rp:content:Photo"..msg.chat_id..":"..text)
local vido = redis:get(bot_id.."Rp:content:Video"..msg.chat_id..":"..text)
local stickr = redis:get(bot_id.."Rp:content:Sticker"..msg.chat_id..":"..text)
local anima = redis:get(bot_id.."Rp:content:Animation"..msg.chat_id..":"..text)
local document = redis:get(bot_id.."Rp:Manager:File"..msg.chat_id..":"..text)
local audio = redis:get(bot_id.."Rp:content:Audio"..msg.chat_id..":"..text)
local VoiceNotecaption = redis:get(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..text) or ""
local photocaption = redis:get(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..text) or ""
local vidocaption = redis:get(bot_id.."Rp:content:Video:caption"..msg.chat_id..":"..text) or ""
local animacaption = redis:get(bot_id.."Rp:content:Animation:caption"..msg.chat_id..":"..text) or ""
local documentcaption = redis:get(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..text) or ""
local audiocaption = redis:get(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..text) or ""
if Text  then
local UserInfo = bot.getUser(msg.sender_id.user_id)
local countMsg = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":message") or 1
local totlmsg = Total_message(countMsg) 
local getst = Get_Rank(msg.sender_id.user_id,msg.chat_id)
local countedit = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Editmessage") or 0
local Text = Text:gsub('#username',(UserInfo.username or 'لا يوجد')):gsub('#name',UserInfo.first_name):gsub('#id',msg.sender_id.user_id):gsub('#edit',countedit):gsub('#msgs',countMsg):gsub('#stast',getst)
if Text:match("]") then
bot.sendText(msg.chat_id,msg.id,""..Text.."","md",true)  
else
bot.sendText(msg.chat_id,msg.id,"["..Text.."]","md",true)  
end
redis:sadd(bot_id.."Spam:Group"..msg.sender_id.user_id,text) 
end
if photo  then
bot.sendPhoto(msg.chat_id, msg.id, photo,photocaption)
redis:sadd(bot_id.."Spam:Group"..msg.sender_id.user_id,text) 
end  
if vido  then
bot.sendVideo(msg.chat_id, msg.id, vido,vidocaption)
redis:sadd(bot_id.."Spam:Group"..msg.sender_id.user_id,text) 
end  
if stickr  then
bot.sendSticker(msg.chat_id, msg.id, stickr,stickrcaption)
redis:sadd(bot_id.."Spam:Group"..msg.sender_id.user_id,text) 
end  
if anima  then
bot.sendAnimation(msg.chat_id, msg.id, anima,animacaption)
redis:sadd(bot_id.."Spam:Group"..msg.sender_id.user_id,text) 
end  
if VoiceNote then
bot.sendVoiceNote(msg.chat_id, msg.id, VoiceNote,"["..VoiceNotecaption.."]", "md")
redis:sadd(bot_id.."Spam:Group"..msg.sender_id.user_id,text) 
end
if document  then
bot.sendDocument(msg.chat_id, msg.id, document,"["..documentcaption.."]", "md")
redis:sadd(bot_id.."Spam:Group"..msg.sender_id.user_id,text) 
end  
if audio  then
bot.sendAudio(msg.chat_id, msg.id, audio,"["..audiocaption.."]", "md")
redis:sadd(bot_id.."Spam:Group"..msg.sender_id.user_id,text) 
end
end 
end


----------------------------------------------------------------------------------------------------
if not redis:sismember(bot_id..'Spam:Group'..msg.sender_id.user_id,text) then
local Text = redis:get(bot_id.."Rp:content:Textg"..msg.chat_id..":"..text)
if Text  then
local UserInfo = bot.getUser(msg.sender_id.user_id)
local countMsg = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":message") or 1
local totlmsg = Total_message(countMsg) 
local getst = Get_Rank(msg.sender_id.user_id,msg.chat_id)
local countedit = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Editmessage") or 0
local Text = Text:gsub('#username',(UserInfo.username or 'لا يوجد')):gsub('#name',UserInfo.first_name):gsub('#id',msg.sender_id.user_id):gsub('#edit',countedit):gsub('#msgs',countMsg):gsub('#stast',getst)
if Text:match("]") then
bot.sendText(msg.chat_id,msg.id,""..Text.."","md",true)  
else
bot.sendText(msg.chat_id,msg.id,"["..Text.."]","md",true)  
end
redis:sadd(bot_id.."Spam:Group"..msg.sender_id.user_id,text) 
end
end 
----------------------------------------------------------------------------------------------------
if text and redis:sismember(bot_id..'List:arrayy',text) then
local list = redis:smembers(bot_id.."Add:Rd:array:Textt"..text)
return bot.sendText(msg.chat_id,msg.id,"["..list[math.random(#list)].."]","md",true)  
end  
---------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
-- نهايه التفعيل

if redis:get(bot_id..":"..msg.sender_id.user_id..":lov_Bots"..msg.chat_id) == "sendlove" then
num = {"😂 10","🤤 20","😢 30","😔 35","😒 75","🤩 34","😗 66","🤐 82","😪 23","😫 19","😛 55","😜 80","😲 63","😓 32","🙂 27","😎 89","😋 99","😁 98","😀 79","🤣 100","😣 8","🙄 3","😕 6","🤯 0",};
sendnum = num[math.random(#num)]
local tttttt = '⤈︙ نسبة الحب بيـن : '..text..' '..sendnum..' %'
bot.sendText(msg.chat_id,msg.id,tttttt) 
redis:del(bot_id..":"..msg.sender_id.user_id..":lov_Bots"..msg.chat_id)
end
if redis:get(bot_id..":"..msg.sender_id.user_id..":lov_Bottts"..msg.chat_id) == "sendlove" then
num = {"😂 10","🤤 20","😢 30","😔 35","😒 75","🤩 34","😗 66","?? 82","😪 23","😫 19","😛 55","😜 80","😲 63","😓 32","🙂 27","😎 89","😋 99","😁 98","😀 79","🤣 100","😣 8","🙄 3","😕 6","🤯 0",};
sendnum = num[math.random(#num)]
local tttttt = '⤈︙ نسبة غباء : '..text..' '..sendnum..' %'
bot.sendText(msg.chat_id,msg.id,tttttt) 
redis:del(bot_id..":"..msg.sender_id.user_id..":lov_Bottts"..msg.chat_id)
end
if redis:get(bot_id..":"..msg.sender_id.user_id..":lov_Botttuus"..msg.chat_id) == "sendlove" then
num = {"😂 10","🤤 20","😢 30","😔 35","😒 75","🤩 34","😗 66","🤐 82","😪 23","😫 19","😛 55","😜 80","😲 63","😓 32","🙂 27","😎 89","😋 99","😁 98","😀 79","🤣 100","😣 8","🙄 3","😕 6","🤯 0",};
sendnum = num[math.random(#num)]
local tttttt = '⤈︙ نسبة الذكاء : '..text..' '..sendnum..' %'
bot.sendText(msg.chat_id,msg.id,tttttt) 
redis:del(bot_id..":"..msg.sender_id.user_id..":lov_Botttuus"..msg.chat_id)
end
if text and redis:get(bot_id..":"..msg.sender_id.user_id..":krh_Bots"..msg.chat_id) == "sendkrhe" then
num = {"😂 10","🤤 20","😢 30","😔 35","😒 75","🤩 34","😗 66","🤐 82","😪 23","😫 19","😛 55","😜 80","😲 63","😓 32","🙂 27","😎 89","😋 99","😁 98","😀 79","🤣 100","😣 8","🙄 3","😕 6","🤯 0",};
sendnum = num[math.random(#num)]
local tttttt = '⤈︙ نسبه الكره : '..text..' '..sendnum..' %'
bot.sendText(msg.chat_id,msg.id,tttttt) 
redis:del(bot_id..":"..msg.sender_id.user_id..":krh_Bots"..msg.chat_id)
end
if text and text ~="نسبه الرجوله" and redis:get(bot_id..":"..msg.sender_id.user_id..":rjo_Bots"..msg.chat_id) == "sendrjoe" then
numj = {"?? 10","🤤 20","?? 30","?? 35","😒 75","🤩 34","😗 66","🤐 82","?? 23","😫 19","😛 55","?? 80","😲 63","😓 32","🙂 27","😎 89","😋 99","😁 98","🥰 79","🤣 100","😣 8","🙄 3","😕 6","🤯 0",};
sendnuj = numj[math.random(#numj)]
local tttttt = '⤈︙ نسبة الرجوله : '..text..' '..sendnuj..' %'
bot.sendText(msg.chat_id,msg.id,tttttt) 
redis:del(bot_id..":"..msg.sender_id.user_id..":rjo_Bots"..msg.chat_id)
end
if text and text ~="نسبه الانوثه" and redis:get(bot_id..":"..msg.sender_id.user_id..":ano_Bots"..msg.chat_id) == "sendanoe" then
numj = {"😂 10","🤤 20","😢 30","😔 35","😒 75","🤩 34","😗 66","🤐 82","😪 23","😫 19","😛 55","😜 80","😲 63","😓 32","🙂 27","?? 89","😋 99","?? 98","😀 79","🤣 100","😣 8","🙄 3","😕 6","🤯 0",};
sendnuj = numj[math.random(#numj)]
local tttttt = '⤈︙ نسبه الانوثة : '..text..' '..sendnuj..' %'
bot.sendText(msg.chat_id,msg.id,tttttt) 
redis:del(bot_id..":"..msg.sender_id.user_id..":ano_Bots"..msg.chat_id)
end

if redis:get(bot_id..'Status:aktbas'..msg.chat_id) == 'true' then
if msg.forward_info or text or msg.content.video_note or msg.content.document or msg.content.audio or msg.content.video or msg.content.voice_note or msg.content.sticker or msg.content.animation or msg.content.photo then
bot.sendText(msg.chat_id,0,"-","md",true)
end
end
-- نهايه التفعيل
if text == 'السورس' or text == 'سورس' or text == 'ياسورس' or text == 'يا سورس' then 
local Text = "*˛ 𝗪𝗘𝗟𝗖𝗢𝗠 𝗧𝗢 𝗦𝗢𝗨𝗥𝗖𝗘 𝗧𝗜𝗠𝗘 .*\n"
keyboard = {} 
keyboard.inline_keyboard = {
{{text = '‹ Source Time ›',url="https://t.me/YAYYYYYY"}}
}
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. msg.chat_id .. "&photo=https://t.me/YAYYYYYY&caption=".. URL.escape(Text).."&photo=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
----------------------------------------------------------------------------------------------------
if text and text:match("^تعيين عدد الاعضاء (%d+)$") then
if not devB(msg.sender_id.user_id) then 
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المطور الاساسي * ',"md",true)  
end
redis:set(bot_id..'Num:Add:Bot',text:match("تعيين عدد الاعضاء (%d+)$") ) 
bot.sendText(msg.chat_id,msg.id,'*⤈︙ تم تعيين عدد اعضاء تفعيل البوت\n اكثر من ( '..text:match("تعيين عدد الاعضاء (%d+)$")..' ) عضو *',"md",true)  
end

if text and text:match("^حظر كروب (.*)$") then
if not devB(msg.sender_id.user_id) then 
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المطور الاساسي * ',"md",true)  
end
local txx = text:match("^حظر كروب (.*)$")
if txx:match("^-100(%d+)$") then
redis:sadd(bot_id..'ban:online',txx)
bot.sendText(msg.chat_id,msg.id,'\n⤈︙ تم حظر الكروب من البوت ',"md",true)  
else
bot.sendText(msg.chat_id,msg.id,'\n⤈︙ اكتب ايدي الكروب بشكل صحيح ',"md",true)  
end
end
if text and text:match("^الغاء حظر كروب (.*)$") then
if not devB(msg.sender_id.user_id) then 
return bot.sendText(msg.chat_id,msg.id,'\n*⤈︙ هذا الامر يخص المطور الاساسي * ',"md",true)  
end
local txx = text:match("^الغاء حظر كروب (.*)$")
if txx:match("^-100(%d+)$") then
redis:srem(bot_id..'ban:online',txx)
bot.sendText(msg.chat_id,msg.id,'\n⤈︙ تم الغاء حظر الكروب من البوت ',"md",true)  
else
bot.sendText(msg.chat_id,msg.id,'\n⤈︙ اكتب ايدي الكروب بشكل صحيح ',"md",true)  
end
end
if text == 'تفعيل' then
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذراً البوت ليس ادمن في المجموعه .*","md",true)  
return false
end
sm = bot.getChatMember(msg.chat_id,msg.sender_id.user_id)
if not developer(msg) then
if sm.status.luatele ~= "chatMemberStatusCreator" and sm.status.luatele ~= "chatMemberStatusAdministrator" then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذراً يجب أنْ تكون مشرف او مالك المجموعه .*","md",true)  
return false
end
if not redis:get(bot_id..":sendbot") then
local UserInfo = bot.getUser(sudoid)
if UserInfo.username and UserInfo.username ~= "" then
ude = 't.me/'..UserInfo.username
else
ude = 'tg://user?id='..UserInfo.id
end
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ مطور البوت ›',url=ude}},
{{text = '‹ قناة السورس ›',url="https://t.me/YAYYYYYY"}},
}
}
bot.sendText(msg.chat_id,msg.id,'*⤈︙ عذراً تم تعطيل البوت الخدمي يمكن للمطور فقط تفعيل البوت .*',"md", true, false, false, false, reply_markup)
return false
end
end
if sm.status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",msg.sender_id.user_id)
else
local info_ = bot.getSupergroupMembers(msg.chat_id, "Administrators", "*", 0, 200)
local list_ = info_.members
for k, v in pairs(list_) do
if info_.members[k].status.luatele == "chatMemberStatusCreator" then
local UserInfo = bot.getUser(v.member_id.user_id)
if UserInfo.first_name and UserInfo.first_name ~= "" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",v.member_id.user_id)
end
end
end
redis:sadd(bot_id..":"..msg.chat_id..":Status:Administrator",msg.sender_id.user_id)
end
if redis:sismember(bot_id..":Groups",msg.chat_id) then
 bot.sendText(msg.chat_id,msg.id,'*⤈︙ تم تفعيل المجموعه سابقا .*',"md",true)  
return false
else
Get_Chat = bot.getChat(msg.chat_id)
Info_Chats = bot.getSupergroupFullInfo(msg.chat_id)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = Get_Chat.title, url = Info_Chats.invite_link.invite_link}},
{{text = '‹ Source Time ›',url="t.me/YAYYYYYY"}},
}
}

UserInfo = bot.getUser(msg.sender_id.user_id).first_name
bot.sendText(sudoid,0,'*\n⤈︙ تم تفعيل مجموعه جديده \n⤈︙ بواسطه : (*['..UserInfo..'](tg://user?id='..msg.sender_id.user_id..')*)\n⤈︙ معلومات المجموعه :\n⤈︙ عدد الاعضاء : '..Info_Chats.member_count..'\n⤈︙ عدد الادمنيه : '..Info_Chats.administrator_count..'\n⤈︙ عدد المطرودين : '..Info_Chats.banned_count..'\n⤈︙ عدد المقيدين : '..Info_Chats.restricted_count..'\n⤈︙ الرابط\n : '..Info_Chats.invite_link.invite_link..'*',"md", true, false, false, false, reply_markup)
bot.sendText(msg.chat_id,msg.id,'*\n⤈︙ عزيزي : *['..UserInfo..'](tg://user?id='..msg.sender_id.user_id..')*\n⤈︙ تم تفعيل المجموعه بنجاح .\n⤈︙ عدد الاعضاء : '..Info_Chats.member_count..' .\n⤈︙ عدد الادمنيه : '..Info_Chats.administrator_count.. ' .*',"md", true, false, false, false, reply_markup)
redis:sadd(bot_id..":Groups",msg.chat_id)
end
end
if text == 'تعطيل' then
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذراً البوت ليس ادمن في المجموعه .*","md",true)  
return false
end
sm = bot.getChatMember(msg.chat_id,msg.sender_id.user_id)
if not developer(msg) then
if sm.status.luatele ~= "chatMemberStatusCreator"then
bot.sendText(msg.chat_id,msg.id,"*⤈︙ عذراً يجب أنْ تكون مالك المجموعه .*","md",true)  
return false
end
end
if redis:sismember(bot_id..":Groups",msg.chat_id) then
Get_Chat = bot.getChat(msg.chat_id)
Info_Chats = bot.getSupergroupFullInfo(msg.chat_id)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = Get_Chat.title, url = Info_Chats.invite_link.invite_link}},
{{text = '‹ Source Time ›',url="t.me/YAYYYYYY"}},
}
}
UserInfo = bot.getUser(msg.sender_id.user_id).first_name
bot.sendText(sudoid,0,'*\n⤈︙ تم تعطيل المجموعه التاليه :⤈︙  \n⤈︙ بواسطه : (*['..UserInfo..'](tg://user?id='..msg.sender_id.user_id..')*)\n⤈︙ معلومات المجموعه :\n⤈︙ عدد الاعضاء : '..Info_Chats.member_count..'\n⤈︙ عدد الادمنيه : '..Info_Chats.administrator_count..'\n⤈︙ عدد المطرودين : '..Info_Chats.banned_count..'\n⤈︙ عدد المقيدين : '..Info_Chats.restricted_count..'\n⤈︙ الرابط\n : '..Info_Chats.invite_link.invite_link..'*',"md", true, false, false, false, reply_markup)
bot.sendText(msg.chat_id,msg.id,'*\n⤈︙ عزيزي : *['..UserInfo..'](tg://user?id='..msg.sender_id.user_id..')*\n⤈︙ تم تعطيل المجموعه بنجاح .\n⤈︙ عدد الاعضاء : '..Info_Chats.member_count..' .\n⤈︙ عدد الادمنيه : '..Info_Chats.administrator_count.. ' .*',"md", true, false, false, false, reply_markup)
redis:srem(bot_id..":Groups",msg.chat_id)
local keys = redis:keys(bot_id..'*'..'-100'..data.supergroup.id..'*')
redis:del(bot_id..":"..msg.chat_id..":Status:Creator")
redis:del(bot_id..":"..msg.chat_id..":Status:BasicConstructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Constructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Owner")
redis:del(bot_id..":"..msg.chat_id..":Status:Administrator")
redis:del(bot_id..":"..msg.chat_id..":Status:Vips")
redis:del(bot_id.."List:Command:"..msg.chat_id)
for i = 1, #keys do 
redis:del(keys[i])
end
return false
else
bot.sendText(msg.chat_id,msg.id,'*⤈︙ المجموعه معطله بالفعل .*',"md", true)
end
end
----------------------------------------------------------------------------------------------------
end --- end Run
end --- end Run
----------------------------------------------------------------------------------------------------
function Call(data)
if data and data.luatele and data.luatele == "updateSupergroup" then
local Get_Chat = bot.getChat('-100'..data.supergroup.id)
if data.supergroup.status.luatele == "chatMemberStatusBanned" then
redis:srem(bot_id..":Groups",'-100'..data.supergroup.id)
local keys = redis:keys(bot_id..'*'..'-100'..data.supergroup.id..'*')
redis:del(bot_id..":-100"..data.supergroup.id..":Status:Creator")
redis:del(bot_id..":-100"..data.supergroup.id..":Status:BasicConstructor")
redis:del(bot_id..":-100"..data.supergroup.id..":Status:Constructor")
redis:del(bot_id..":-100"..data.supergroup.id..":Status:Owner")
redis:del(bot_id..":-100"..data.supergroup.id..":Status:Administrator")
redis:del(bot_id..":-100"..data.supergroup.id..":Status:Vips")
redis:del(bot_id.."List:Command:"..'-100'..data.supergroup.id)
for i = 1, #keys do 
redis:del(keys[i])
end
if data.supergroup.restriction_reason and data.supergroup.restriction_reason:match("^The admins (.*) content (.*)") then
bot.sendText("-100"..data.supergroup.id,data.message.id,"*⤈︙ لا يمكن للبوت ان يعمل  بمجموعه تقيد المحتوى .*","md",true)  
local Left_Bot = bot.leaveChat("-100"..data.supergroup.id)
end 
if redis:get(bot_id..":Notice") then
Get_Chat = bot.getChat('-100'..data.supergroup.id)
Info_Chats = bot.getSupergroupFullInfo('-100'..data.supergroup.id)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = Get_Chat.title, url = Info_Chats.invite_link.invite_link}},
}
}
return bot.sendText(sudoid,0,'⤈︙ تم طرد البوت من مجموعه جديده .\n⤈︙ معلومات المجموعه :\n⤈︙ الايدي : ( `-100'..data.supergroup.id..'` )\n*⤈︙ عدد الاعضاء : '..Info_Chats.member_count..'\n⤈︙ عدد الادمنيه : '..Info_Chats.administrator_count..'\n⤈︙ عدد المطرودين : '..Info_Chats.banned_count..'\n⤈︙ عدد المقيدين : '..Info_Chats.restricted_count..'\n⤈︙ الرابط\n : '..Info_Chats.invite_link.invite_link..'*',"md",true, false, false, false, reply_markup)
end
end
end
print(serpent.block(data, {comment=false}))   
if data and data.luatele and data.luatele == "updateNewMessage" then
if data.message.sender_id.luatele == "messageSenderChat" then
---if nfRankrestriction(data.message.chat_id,restrictionGet_Rank(data.message.sender_id.user_id,data.message.chat_id),"messageSenderChat") then
---bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
---end
if redis:get(bot_id..":"..data.message.chat_id..":settings:messageSenderChat") == "del" then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
return false
end
end
if data.message.sender_id.luatele ~= "messageSenderChat" then
if tonumber(data.message.sender_id.user_id) ~= tonumber(bot_id) then  
if data.message.content.text and data.message.content.text.text:match("^(.*)$") then
if redis:get(bot_id..":"..data.message.chat_id..":"..data.message.sender_id.user_id..":Command:del") == "true" then
redis:del(bot_id..":"..data.message.chat_id..":"..data.message.sender_id.user_id..":Command:del")
if redis:get(bot_id..":"..data.message.chat_id..":Command:"..data.message.content.text.text) then
redis:del(bot_id..":"..data.message.chat_id..":Command:"..data.message.content.text.text)
redis:srem(bot_id.."List:Command:"..data.message.chat_id,data.message.content.text.text)
t = "⤈︙ تم حذف الامر بنجاح ."
else
t = " ⤈︙ عذراً الامر  ( "..data.message.content.text.text.." ) غير موجود "
end
bot.sendText(data.message.chat_id,data.message.id,"*"..t.."*","md",true)  
end
end
if data.message.content.text and data.message.content.text.text:match('^'..namebot..' ') then
data.message.content.text.text = data.message.content.text.text:gsub('^'..namebot..' ','')
end
if data.message.content.text then
local NewCmd = redis:get(bot_id..":"..data.message.chat_id..":Command:"..data.message.content.text.text)
if NewCmd then
data.message.content.text.text = (NewCmd or data.message.content.text.text)
end
end
if data.message.content.text then
td = data.message.content.text.text
if redis:get(bot_id..":TheCh") then
infokl = bot.getChatMember(redis:get(bot_id..":TheCh"),bot_id)
if infokl and infokl.status and infokl.status.luatele == "chatMemberStatusAdministrator" then
if not devS(data.message.sender_id.user_id) then
if td == "/start" or  td == "ايدي" or  td == "الرابط" or  td == "قفل الكل" or  td == "فتح الكل" or  td == "الاوامر" or  td == "م1" or  td == "م2" or  td == "م3" or  td == "كشف" or  td == "رتبتي" or  td == "المنشئ" or  td == "قفل الصور" or  td == "قفل الالعاب" or  td == "الالعاب" or  td == "العكس" or  td == "روليت" or  td == "كت" or  td == "تنزيل الكل" or  td == "رفع ادمن" or  td == "رفع مميز" or  td == "رفع منشئ" or  td == "المكتومين" or  td == "قفل المتحركات"  then
if bot.getChatMember(redis:get(bot_id..":TheCh"),data.message.sender_id.user_id).status.luatele == "chatMemberStatusLeft" then
Get_Chat = bot.getChat(redis:get(bot_id..":TheCh"))
Info_Chats = bot.getSupergroupFullInfo(redis:get(bot_id..":TheCh"))
if Info_Chats and Info_Chats.invite_link and Info_Chats.invite_link.invite_link and  Get_Chat and Get_Chat.title then 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = Get_Chat.title,url=Info_Chats.invite_link.invite_link}},
}
}
return bot.sendText(data.message.chat_id,data.message.id,Reply_Status(data.message.sender_id.user_id,"*⤈︙ عليك الاشتراك في قناة البوت اولاً  .*").yu,"md", true, false, false, false, reply_dev)
end
end
end
end
end
end
end
if (data.message.content.text and data.message.content.text.text:match("displayed")) then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
end
if redis:sismember(bot_id..":bot:Ban", data.message.sender_id.user_id) then    
if GetInfoBot(data.message).BanUser then
bot.setChatMemberStatus(data.message.chat_id,data.message.sender_id.user_id,'banned',0)
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
return false
elseif GetInfoBot(data.message).BanUser == false then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
return false
end
end  
if redis:sismember(bot_id..":bot:Ban", data.message.sender_id.user_id) then    
if GetInfoBot(data.message).BanUser then
bot.setChatMemberStatus(data.message.chat_id,data.message.sender_id.user_id,'banned',0)
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
return false
elseif GetInfoBot(data.message).BanUser == false then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
return false
end
end  
if redis:sismember(bot_id..":bot:silent", data.message.sender_id.user_id) then    
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
end  
if redis:sismember(bot_id..":"..data.message.chat_id..":silent", data.message.sender_id.user_id) then    
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})  
end
if redis:sismember(bot_id..":"..data.message.chat_id..":Ban", data.message.sender_id.user_id) then    
if GetInfoBot(data.message).BanUser then
bot.setChatMemberStatus(data.message.chat_id,data.message.sender_id.user_id,'banned',0)
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
elseif GetInfoBot(data.message).BanUser == false then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
end
end 
if redis:sismember(bot_id..":"..data.message.chat_id..":restrict", data.message.sender_id.user_id) then    
bot.setChatMemberStatus(data.message.chat_id,data.message.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
end  
if not Administrator(msg) then
if data.message.content.text then
hash = redis:sismember(bot_id.."mn:content:Text"..data.message.chat_id, data.message.content.text.text)
tu = "الرساله"
ut = "ممنوعه"
elseif data.message.content.sticker then
hash = redis:sismember(bot_id.."mn:content:Sticker"..data.message.chat_id, data.message.content.sticker.sticker.remote.unique_id)
tu = "الملصق"
ut = "ممنوع"
elseif data.message.content.animation then
hash = redis:sismember(bot_id.."mn:content:Animation"..data.message.chat_id, data.message.content.animation.animation.remote.unique_id)
tu = "المتحركه"
ut = "ممنوعه"
elseif data.message.content.photo then
hash = redis:sismember(bot_id.."mn:content:Photo"..data.message.chat_id, data.message.content.photo.sizes[1].photo.remote.unique_id)
tu = "الصوره"
ut = "ممنوعه"
end
if hash then    
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
bot.sendText(data.message.chat_id,data.message.id,Reply_Status(data.message.sender_id.user_id,"*⤈︙ "..tu.." "..ut.." من المجموعه*").yu,"md",true)  
end
end
if data.message and data.message.content then
if data.message.content.luatele == "messageSticker" or data.message.content.luatele == "messageUnsupported" or data.message.content.luatele == "messageContact" or data.message.content.luatele == "messageVideoNote" or data.message.content.luatele == "messageDocument" or data.message.content.luatele == "messageVideo" or data.message.content.luatele == "messageAnimation" or data.message.content.luatele == "messagePhoto" then
redis:sadd(bot_id..":"..data.message.chat_id..":mediaAude:ids",data.message.id)  
end
end
Run(data.message,data)
if data.message.content.text then
if data.message.content.text and not redis:sismember(bot_id..'Spam:Group'..data.message.sender_id.user_id,data.message.content.text.text) then
redis:del(bot_id..'Spam:Group'..data.message.sender_id.user_id) 
end
end
if data.message.content.luatele == "messageChatJoinByLink" then
if redis:get(bot_id..":"..data.message.chat_id..":settings:JoinByLink")== "del" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender_id.user_id) 
bot.setChatMemberStatus(data.message.chat_id,data.message.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender_id.user_id,'banned',0)
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:JoinByLink")== "ked" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender_id.user_id) 
bot.setChatMemberStatus(data.message.chat_id,data.message.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender_id.user_id,'banned',0)
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:JoinByLink") == "ktm" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender_id.user_id) 
bot.setChatMemberStatus(data.message.chat_id,data.message.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender_id.user_id,'banned',0)
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:JoinByLink")== "kick" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender_id.user_id) 
bot.setChatMemberStatus(data.message.chat_id,data.message.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender_id.user_id,'banned',0)
end
end
if data.message.content.luatele == "messageChatDeleteMember" or data.message.content.luatele == "messageChatAddMembers" or data.message.content.luatele == "messagePinMessage" or data.message.content.luatele == "messageChatChangeTitle" or data.message.content.luatele == "messageChatJoinByLink" then
if redis:get(bot_id..":"..data.message.chat_id..":settings:Tagservr")== "del" then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:Tagservr")== "ked" then
bot.setChatMemberStatus(data.message.chat_id,data.message.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:Tagservr") == "ktm" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender_id.user_id) 
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:Tagservr")== "kick" then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender_id.user_id,'banned',0)
end
end 
end

if data.message.content.luatele == "messageChatJoinByLink" and redis:get(bot_id..'Status:joinet'..data.message.chat_id) == 'true' then
    local reply_markup = bot.replyMarkup{
    type = 'inline',
    data = {
    {
    {text = '‹ انا لست بوت ›', data = data.message.sender_id.user_id..'/UnKed'},
    },
    }
    } 
    bot.setChatMemberStatus(data.message.chat_id,data.message.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
    return bot.sendText(data.message.chat_id, data.message.id, '⤈︙ قم بأختيار انا لست بوت لتخطي التحقق .', 'md',false, false, false, false, reply_markup)
    end
    
if data.message.content.luatele == "messageChatJoinByLink" then
if not redis:get(bot_id..":"..data.message.chat_id..":settings:Welcome") then
local UserInfo = bot.getUser(data.message.sender_id.user_id)
local tex = redis:get(bot_id..":"..data.message.chat_id..":Welcome")
if UserInfo.username and UserInfo.username ~= "" then
User = "[@"..UserInfo.username.."]"
Usertag = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
else
User = "لا يوجد"
Usertag = '['..UserInfo.first_name..'](tg://user?id='..data.message.sender_id.user_id..')'
end
if tex then 
tex = tex:gsub('name',UserInfo.first_name) 
tex = tex:gsub('user',User) 
bot.sendText(data.message.chat_id,data.message.id,tex,"md")  
else
bot.sendText(data.message.chat_id,data.message.id,"Hello 💗 .","md",true)
end
end
end

if data.message.content.luatele == "messageChatAddMembers" and redis:get(bot_id..":infobot") then 
if data.message.content.member_user_ids[1] == tonumber(bot_id) then 
local photo = bot.getUserProfilePhotos(bot_id)
kup = bot.replyMarkup{
type = 'inline',data = {
{{text ="⤈︙ اضفني لكروبك .",url="https://t.me/"..bot.getMe().username.."?startgroup=new"}},
}
}
if photo.total_count > 0 then
bot.sendPhoto(data.message.chat_id, data.message.id, photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id,"*⤈︙ انا بوت اسمي تريكس\n⤈︙ اختصاصي حماية المجموعهات وادارتها\n⤈︙ يوتيوب، تشغيل الاغاني في المكالمه ، العاب، كت تويت، والعديد من الميزات اكتشفها بنفسك\n⤈︙ والأفضل من هذا ان البوت مبرمج على النسخة الجديدة 64 بت خالٍ من المشاكل .\n⤈︙ علمود تفعلني ارفعني مشرف بس *", 'md', nil, nil, nil, nil, nil, nil, nil, nil, nil, kup)
else
bot.sendText(data.message.chat_id,data.message.id,"*⤈︙ انا بوت اسمي تريكس\n⤈︙ اختصاصي حماية المجموعهات وادارتها\n⤈︙ يوتيوب، تشغيل الاغاني في المكالمه ، العاب، كت تويت، والعديد من الميزات اكتشفها بنفسك\n⤈︙ والأفضل من هذا ان البوت مبرمج على النسخة الجديدة 64 بت خالٍ من المشاكل .\n⤈︙ علمود تفعلني ارفعني مشرف بس *","md",true, false, false, false, kup)
end
end
end
end
elseif data and data.luatele and data.luatele == "updateMessageEdited" then
local msg = bot.getMessage(data.chat_id, data.message_id)
if tonumber(msg.sender_id.user_id) ~= tonumber(bot_id) then  
if redis:sismember(bot_id..":bot:silent", msg.sender_id.user_id) then    
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end  
if redis:sismember(bot_id..":"..msg.chat_id..":silent", msg.sender_id.user_id) then    
bot.deleteMessages(msg.chat_id,{[1]= msg.id})  
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", msg.sender_id.user_id) then    
if GetInfoBot(msg).BanUser then
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'banned',0)
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif GetInfoBot(msg).BanUser == false then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end
end  
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", msg.sender_id.user_id) then    
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
end  
if not Administrator(msg) then
if msg.content.text then
hash = redis:sismember(bot_id.."mn:content:Text"..msg.chat_id, msg.content.text.text)
tu = "الرساله"
ut = "ممنوعه"
elseif msg.content.sticker then
hash = redis:sismember(bot_id.."mn:content:Sticker"..msg.chat_id, msg.content.sticker.sticker.remote.unique_id)
tu = "الملصق"
ut = "ممنوع"
elseif msg.content.animation then
hash = redis:sismember(bot_id.."mn:content:Animation"..msg.chat_id, msg.content.animation.animation.remote.unique_id)
tu = "المتحركه"
ut = "ممنوعه"
elseif msg.content.photo then
hash = redis:sismember(bot_id.."mn:content:Photo"..msg.chat_id, msg.content.photo.sizes[1].photo.remote.unique_id)
tu = "الصوره"
ut = "ممنوعه"
end
if hash then    
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender_id.user_id,"*⤈︙ "..tu.." "..ut.." من المجموعه .*").yu,"md",true)  
end  
end
if text and text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or 
text and text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or 
text and text:match("[Tt].[Mm][Ee]/") or
text and text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or 
text and text:match(".[Pp][Ee]") or 
text and text:match("[Hh][Tt][Tt][Pp][Ss]://") or 
text and text:match("[Hh][Tt][Tt][Pp]://") or 
text and text:match("[Ww][Ww][Ww].") or 
text and text:match(".[Cc][Oo][Mm]") or 
text and text:match("[Hh][Tt][Tt][Pp][Ss]://") or 
text and text:match("[Hh][Tt][Tt][Pp]://") or 
text and text:match("[Ww][Ww][Ww].") or 
text and text:match(".[Cc][Oo][Mm]") or 
text and text:match(".[Tt][Kk]") or 
text and text:match(".[Mm][Ll]") or 
text and text:match(".[Oo][Rr][Gg]") then 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end
Run(msg,data)
redis:incr(bot_id..":"..msg.chat_id..":"..msg.sender_id.user_id..":Editmessage") 
----------------------------------------------------------------------------------------------------
if not BasicConstructor(msg) then
if nfGdone(msg,msg.chat_id,msg.sender_id.user_id,"Edited") then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end
if nfRankrestriction(msg,msg.chat_id,restrictionGet_Rank(msg.sender_id.user_id,msg.chat_id),"Edited") then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end
if msg.content.luatele == "messageContact" or msg.content.luatele == "messageVideoNote" or msg.content.luatele == "messageDocument" or msg.content.luatele == "messageAudio" or msg.content.luatele == "messageVideo" or msg.content.luatele == "messageVoiceNote" or msg.content.luatele == "messageAnimation" or msg.content.luatele == "messagePhoto" then
if redis:get(bot_id..":"..msg.chat_id..":settings:Edited") then
if redis:get(bot_id..":"..msg.chat_id..":settings:Edited") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Edited") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Edited") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender_id.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Edited") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender_id.user_id,'banned',0)
end
ued = bot.getUser(msg.sender_id.user_id)
ues = " العضو ["..ued.first_name.."](tg://user?id="..msg.sender_id.user_id..") "
infome = bot.getSupergroupMembers(msg.chat_id, "Administrators", "*", 0, 200)
lsme = infome.members
t = "*⤈︙ قام ( *"..ues.."* ) بتعديل رسالته \n ٴ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉ \n*"
for k, v in pairs(lsme) do
if infome.members[k].bot_info == nil then
local UserInfo = bot.getUser(v.member_id.user_id)
if UserInfo.username ~= "" then
t = t..""..k.."- [@"..UserInfo.username.."]\n"
else
t = t..""..k.."- ["..UserInfo.first_name.."](tg://user?id="..v.member_id.user_id..")\n"
end
end
end
if #lsme == 0 then
t = "*⤈︙ لا يوجد مشرفين في الكروب*"
end
bot.sendText(msg.chat_id,msg.id,t,"md", true)
end
end
end
end
elseif data and data.luatele and data.luatele == "updateNewInlineCallbackQuery" then
local Text = bot.base64_decode(data.payload.data)
if Text and Text:match('/Hmsa1@(%d+)@(%d+)/(%d+)') then
local ramsesadd = {string.match(Text,"^/Hmsa1@(%d+)@(%d+)/(%d+)$")}
if tonumber(data.sender_user_id) == tonumber(ramsesadd[1]) or tonumber(ramsesadd[2]) == tonumber(data.sender_user_id) then
local inget = redis:get(bot_id..'hmsabots'..ramsesadd[3]..data.sender_user_id)
https.request("https://api.telegram.org/bot"..Token..'/answerCallbackQuery?callback_query_id='..data.id..'&text='..URL.escape(inget)..'&show_alert=true')
else
https.request("https://api.telegram.org/bot"..Token..'/answerCallbackQuery?callback_query_id='..data.id..'&text='..URL.escape('𖦹 هذه الهمسه ليست لك 𖦹')..'&show_alert=true')
end
end
elseif data and data.luatele and data.luatele == "updateNewInlineQuery" then
local Text = data.query
if Text and Text:match("^(.*) @(.*)$")  then
local username = {string.match(Text,"^(.*) @(.*)$")}
local UserId_Info = bot.searchPublicChat(username[2])
if UserId_Info.id then
local idnum = math.random(1,64)
local input_message_content = {message_text = 'هذه الهمسه للحلو ( [@'..username[2]..'] ) هو اللي يقدر يشوفها 📧', parse_mode = 'Markdown'}	
local reply_markup = {inline_keyboard={{{text = 'فتح الهمسه 📬', callback_data = '/Hmsa1@'..data.sender_user_id..'@'..UserId_Info.id..'/'..idnum}}}}	
local resuult = {{type = 'article', id = idnum, title = 'هذه همسه سريه الى [@'..username[2]..']', input_message_content = input_message_content, reply_markup = reply_markup}}	
https.request("https://api.telegram.org/bot"..Token..'/answerInlineQuery?inline_query_id='..data.id..'&results='..JSON.encode(resuult))
redis:set(bot_id..'hmsabots'..idnum..UserId_Info.id,username[1])
redis:set(bot_id..'hmsabots'..idnum..data.sender_user_id,username[1])
end
end

elseif data and data.luatele and data.luatele == "updateNewCallbackQuery" then
Callback(data)
elseif data and data.luatele and data.luatele == "updateMessageSendSucceeded" then

local msg = data.message
local Chat = msg.chat_id
if msg.content.text then
text = msg.content.text.text
end
if msg.content.video_note then
if msg.content.video_note.video.remote.id == redis:get(bot_id.."PinMsegees:"..msg.chat_id) then
bot.pinChatMessage(msg.chat_id,msg.id,true)
redis:del(bot_id.."PinMsegees:"..msg.chat_id)
end
elseif msg.content.photo then
if msg.content.photo.sizes[1].photo.remote.id then
idPhoto = msg.content.photo.sizes[1].photo.remote.id
elseif msg.content.photo.sizes[2].photo.remote.id then
idPhoto = msg.content.photo.sizes[2].photo.remote.id
elseif msg.content.photo.sizes[3].photo.remote.id then
idPhoto = msg.content.photo.sizes[3].photo.remote.id
end
if idPhoto == redis:get(bot_id.."PinMsegees:"..msg.chat_id) then
bot.pinChatMessage(msg.chat_id,msg.id,true)
redis:del(bot_id.."PinMsegees:"..msg.chat_id)
end
elseif msg.content.sticker then 
if msg.content.sticker.sticker.remote.id == redis:get(bot_id.."PinMsegees:"..msg.chat_id) then
bot.pinChatMessage(msg.chat_id,msg.id,true)
redis:del(bot_id.."PinMsegees:"..msg.chat_id)
end
elseif msg.content.voice_note then 
if msg.content.voice_note.voice.remote.id == redis:get(bot_id.."PinMsegees:"..msg.chat_id) then
bot.pinChatMessage(msg.chat_id,msg.id,true)
redis:del(bot_id.."PinMsegees:"..msg.chat_id)
end
elseif msg.content.video then 
if msg.content.video.video.remote.id == redis:get(bot_id.."PinMsegees:"..msg.chat_id) then
bot.pinChatMessage(msg.chat_id,msg.id,true)
redis:del(bot_id.."PinMsegees:"..msg.chat_id)
end
elseif msg.content.animation then 
if msg.content.animation.animation.remote.id ==  redis:get(bot_id.."PinMsegees:"..msg.chat_id) then
bot.pinChatMessage(msg.chat_id,msg.id,true)
redis:del(bot_id.."PinMsegees:"..msg.chat_id)
end
elseif msg.content.document then
if msg.content.document.document.remote.id == redis:get(bot_id.."PinMsegees:"..msg.chat_id) then
bot.pinChatMessage(msg.chat_id,msg.id,true)
redis:del(bot_id.."PinMsegees:"..msg.chat_id)
end
elseif msg.content.audio then
if msg.content.audio.audio.remote.id == redis:get(bot_id.."PinMsegees:"..msg.chat_id) then
bot.pinChatMessage(msg.chat_id,msg.id,true)
redis:del(bot_id.."PinMsegees:"..msg.chat_id)
end
elseif text then
if text == redis:get(bot_id.."PinMsegees:"..msg.chat_id) then
bot.pinChatMessage(msg.chat_id,msg.id,true)
redis:del(bot_id.."PinMsegees:"..msg.chat_id)
end
end
if data.message and data.message.content then
if data.message.content.luatele == "messageSticker" or data.message.content.luatele == "messageUnsupported" or data.message.content.luatele == "messageContact" or data.message.content.luatele == "messageVideoNote" or data.message.content.luatele == "messageDocument" or data.message.content.luatele == "messageVideo" or data.message.content.luatele == "messageAnimation" or data.message.content.luatele == "messagePhoto" then
redis:sadd(bot_id..":"..data.message.chat_id..":mediaAude:ids",data.message.id)  
end
end
--
end
----------------------------------------------------------------------------------------------------
end
Runbot.run(Call)
