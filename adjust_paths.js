/**
 * This scripts adjusts the paths of `.elpi` files referenced
 * from `.v` files in the implementation of coq-elpi.
 * Because when it is built with Dune, the current working directory
 * is the workspace root, not `workdir`.
 */
var fs = require('fs'),
    child_process = require('child_process');

function findCoqFiles() {
    var c = child_process.spawnSync('find', ['workdir', '-name', '*.v'], {encoding: 'utf-8'});
    return c.output[1].split(/\s+/).filter(x => x);
}

function processFile(filename) {
    var text = fs.readFileSync(filename, 'utf-8');

    text = text.replace(/(Elpi (?:Checker|Template (?:Command|Tactic)|Accumulate File) ")(.*?)("[.])/g,
        (_, pre, fn, suf) => {
        console.log('>> ', fn);
        if (!fn.startsWith('elpi/workdir/')) fn = `elpi/workdir/${fn}`;
        return (pre + fn + suf);
    });
    fs.writeFileSync(filename, text);
}

function main() {
    var l = findCoqFiles();
    for (let fn of l) {
        console.log(fn);
        processFile(fn);
    }
}

main();
