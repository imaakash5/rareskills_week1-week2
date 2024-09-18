const {MerkleTree} = require('merkletreejs');
const keccak256 = require('keccak256');

const whitelistAddresses =['0xe9c524512e3ff3b6807baAFdF7ABD1c8663B123F','0x0Ce7A1aC76594aA47c6b786E3D9863FD6e4Ace79',
    '0x597BbC1e5784c6cBDEDAD5C8A17ada06D0aa283C',
    '0x2d3290E76699C126ca9992c043d108aF3FD27542','0x8d3004834A9F402b4b2B8ee09c3Df2e7d8d6e1a4'];

const leafNodes = whitelistAddresses.map(addr=>keccak256(addr));
const merkleTree = new MerkleTree(leafNodes,keccak256, {sortPairs: true});

const root = merkleTree.getRoot().toString('hex');
console.log("Merkle Root:",root);

const claimingAddress= keccak256('0xe9c524512e3ff3b6807baAFdF7ABD1c8663B123F');
const proof = merkleTree.getProof(claimingAddress).map(x=>x.data.toString('hex'));
console.log(merkleTree.toString('hex'));
console.log('0xe9c524512e3ff3b6807baAFdF7ABD1c8663B123F');
console.log(keccak256('0xe9c524512e3ff3b6807baAFdF7ABD1c8663B123F').toString('hex'));
console.log("Merkle Proof:",proof);