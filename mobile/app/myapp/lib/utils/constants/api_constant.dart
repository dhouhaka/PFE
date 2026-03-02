//for emulator android
// const url = 'http://10.0.2.2:5000/';
//for real device
//(cmd==>ipconfig ==>Carte réseau sans fil Wi-Fi :  Adresse IPv4: 172.16.137.108)
const url = 'http://172.20.10.8:5000/';
//Auth
const register = "${url}auth/registration";
const login = "${url}auth/login";
const getUserById = "${url}auth/getUserById";
const updateUserById = "${url}auth/updateUserById";
//Music
const storeMusic = "${url}music/storeMusic";
const getMusic = "${url}music/getUserMusicList";
const deleteMusicItem = "${url}music/deleteMusic";
