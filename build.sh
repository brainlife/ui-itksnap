docker build -t brainlife/ui-trackvis .
if [ $? -eq 0 ]; then
    docker push brainlife/ui-trackvis
fi
