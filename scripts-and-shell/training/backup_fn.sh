function backup() {
    newname = $1.`date +%Y-%m-%d.%H%M.bak`;
    mv $1 $newname;
    echo "Backed up $1 to $newname.";
    cp -p $newname $1;
}
