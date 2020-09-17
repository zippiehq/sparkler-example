const IpfsHttpClient = require('ipfs-http-client')
const { globSource } = IpfsHttpClient
const ipfs = IpfsHttpClient('https://de-sparklers.dev.zippie.com')

async function init() {  
  const file = await ipfs.add(globSource('/out', { recursive: true }))
  console.log(file.cid.toString())
}

init()