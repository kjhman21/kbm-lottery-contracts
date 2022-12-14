const fs = require('fs')
const common = require('./common.js')
const caver = common.caver
const recipientAddresses = [
"0xD2fEAe72610D69d98576509DeEA48E138d3027a3"
]

async function mint() {
    const keystore = fs.readFileSync(common.filepath, 'utf8')
    const password = await common.loadPassword()
    const deployerKeyring = caver.wallet.keyring.decrypt(keystore, password)
    caver.wallet.add(deployerKeyring)
    console.log('Addr', deployerKeyring.address)

    const kip17 = caver.contract.create(common.abi, common.kip17Address)
    const uri = 'https://klaytn-story-bucket.s3.ap-northeast-2.amazonaws.com/krust.json'

    for(i = 0; i < recipientAddresses.length; i++) {
        const recipientAddres = recipientAddresses[i]
        const out = await kip17.methods.safeMint(recipientAddres, uri).send({from:deployerKeyring.address, gas:10000000})
        console.log(out)
    }
}

mint()