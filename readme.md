# ZeroSecretRoom
## A fully working H5 chatroom implementation with encryption.

中文版本 https://github.com/ericgu2017/0secretroom/blob/master/readme_cn.me

Demo video


### Features

- the chatrom client is a web app. It can be run on Google Chrome, Safari, Android Google Chrome, iOS Safari, Opera and many more. Wechat even but we do __NOT__ recommend doing so.
- ALL transmittions between the relay server and the clients are encrypted with dynamically changing keys (based on AES)
- The relay server doesn't have access to any keys used to encrypt transmissions.
- The relayed messages (and fully encrypted) will be kept on the server for a very short period of time and it will be utterly deleted if all members in the room have recieved the message.
- The relay server keeps everything in memory, it doesn't use Mysql or any other persistant storage.
- The room creator can restore the room after server reboot, fully automaticlally
- It support jpg/png/gif/mp4/mkv and much more files to be uploaded and shows in the chatroom.
- Mobile devices tested: iPad Pro (10 inches), iPhone 6/7/8/XR, Oneplus 6T, Samsung Note8.

### What's been used?
- websockets or specifically, Microsoft SignalR, for instant messeging between relay server and the clients.
- AES256 to encrypt all the messeges.
- ECDH used to safely distribute roomkey (AES256 key) on the Internet.
- WebCrypto was used to greatly enhanced the encryption/decryption speed on the web. (https://www.w3.org/TR/WebCryptoAPI/)
- Vue js framework
- dotnet core server web services

### What's for?
- Self-host a small and yet fully functional chatroom for a group of friends to share stuff safely and quietly. (normally <100 users for a tiny virtual server) 
- Your own one-person data relay service to pass something from your phone to your PC or Mac.
- It can support many chatrooms and a lot many users on a more powerful server setting. I will test it out in the future. But the server uses very little memory to run.

### What's not?
- A production grade high level security chatroom used in Gov'nt and any simular situations.
- Anything serious
