if [[ -z "${TAG}" ]]; then
  echo "Tag not set... bailing"
  exit
fi

echo "Building Container..."
docker build -t gcr.io/z19r-com/z19rpw:${TAG} -t gcr.io/z19r-com/z19rpw:latest .
if [ $? -eq 0 ]; then
    echo ...Build OK
else
    echo ...FAILED. Bailing
    exit 1
fi
echo "Pushing Container to GCR..."
docker push gcr.io/z19r-com/z19rpw:${TAG}
docker push gcr.io/z19r-com/z19rpw:latest
if [ $? -eq 0 ]; then
    echo ...Push OK
else
    echo ...FAILED. Bailing
    exit 1
fi
echo "Setting new image to ${TAG}"
kubectl rollout restart deployment z19rpw
if [ $? -eq 0 ]; then
    echo ...Deploy OK
else
    echo ...FAILED. Bailing
    exit 1
fi

echo "Storing Tag in deploy/.current_tag"
echo ${TAG} > deploy/.current_tag
echo "Current Tag ${TAG}"
echo "Done..."
