const Hyper = require('./providers/hyper');

main();

async function main()
{
    let hyperProvider = new Hyper();

    await hyperProvider.bake("config/minimal.yml");
    hyperProvider.start("minimal");
    
}
