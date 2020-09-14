if [[ -z "${TAG}" ]]; then
  echo "Tag not set... bailing"
  exit
fi

echo "Building Container..."
docker build -t gcr.io/z19r-com/z19rpw:${TAG} .
echo "Pushing Container to GCR..."
docker push gcr.io/z19r-com/z19rpw:${TAG}
echo "Setting new image to ${TAG}"
kubectl set image deployment/z19rpw z19rpw=gcr.io/z19r-com/z19rpw:${TAG}

echo "Storing Tag in deploy/.current_tag"
echo ${TAG} > deploy/.current_tag
echo "Current Tag ${TAG}"
echo "Done..."
