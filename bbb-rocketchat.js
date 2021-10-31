async function getChannel(channelName){
    const rocketChatURL=rocketChatURL
    const apiToken=apiToken
    const apiUserID=apiUserID
    const headers= {
      'X-Auth-Token': apiToken,
      'X-User-Id': apiUserID
    }
  
    const channel_details={}
   
    const room_response = await fetch(`https://${rocketChatURL}/api/v1/rooms.info?roomName=${channelName}`, {
            method: 'GET',
            headers: headers
    });
  
  const   channel_response = await fetch(`https://${rocketChatURL}/api/v1/channels.info?roomName=${channelName}`, {
                  method: 'GET',
                  headers: headers
          });
  
    const rooms = await room_response.json()
    const channels = await channel_response.json()
  
  console.log(rooms.success)
  console.log(channels.success)
  if(rooms.success){
    channel_details["type"] = "group"
    channel_details["exist"] = true
  }
  if(channels.success){
    channel_details["type"] = "channel"
    channel_details["exist"] = true
  }
  
  if(!rooms.success && !channels.success) {
    channel_details["exist"] = false
  }
  
  
  return channel_details
  
  }
  
  async function main(){
  
    //const elm = await checkElement("#chat-toggle-button")
    const elm = await checkElement("#layout")
  try {
    if (elm){
            document.querySelectorAll('div[class^="messages"]').forEach(elem => elem.style.display = "none");
            document.querySelector('div[data-test="publicChat"]').style.opacity = 0;
      const heading = document.querySelector("[class^=presentationTitle]");
      const param = heading.innerText;
      const channel = await getChannel(param)
    
      if (channel.exist){
        document.querySelector('[data-test="publicChat"]').style.opacity = 1
    
      let publicChat = document.querySelector("#chat-toggle-button");
      publicChat.style.display = "none";
    
      const userIcon = document.querySelector(
        '*[aria-label^="Users and messages toggle"]'
      );
    
      userIcon.style.display = "none";
    
      const chatHide = document.querySelector('[data-test="publicChat"]');
      chatHide.innerHTML=''
    
      const leftArrow = document.querySelector(".icon-bbb-left_arrow");
      leftArrow.parentNode.removeChild(leftArrow);
    
      var iframe = document.createElement("iframe");
      iframe.classList.add("my-chat");
      iframe.src = ` https://${rocketChatURL}/${channel.type}/${param}?layout=embedded`;
      document.querySelector('[data-test="publicChat"]').appendChild(iframe);
      document.querySelectorAll('div[class^="messages"]').forEach(elem => elem.style.display = "none")
      }
      else{
        // if no rocket chanell found un hide default chat pannel
        document.querySelector('[data-test="publicChat"]').style.opacity = 1
        document.querySelectorAll('div[class^="messages"]').forEach(elem => elem.style.display = "block")
      }
    }
  } catch (error) {
    document.querySelector('[data-test="publicChat"]').style.opacity = 1
    document.querySelectorAll('div[class^="messages"]').forEach(elem => elem.style.display = "block")
  }
  
  }
  main()