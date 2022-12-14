const fs = require('fs')
const common = require('./common.js')
const caver = common.caver

async function burn(tokenId) {

    const keystore = fs.readFileSync(common.filepath, 'utf8')
    const password = await common.loadPassword()
    const deployerKeyring = caver.wallet.keyring.decrypt(keystore, password)
    caver.wallet.add(deployerKeyring)
    console.log('Addr', deployerKeyring.address)

    const kip17 = caver.contract.create(common.abi, common.kip17Address)

    const out = await kip17.methods.burn(tokenId).send({from:deployerKeyring.address, gas:1000000})

    console.log(out)
}


const tokenId = 2
burn(tokenId)