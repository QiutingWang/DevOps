def buildApp(){
  echo "building the application..."
  echo "Building version ${NEW_VERSION}" //if we want it to be a string, we need double quotation mark.
}

def testApp(){
  echo "testing the application..."
}

def deployApp(){
  echo "deploying the application..."
  echo "deploying version ${params.VERSION}"
}

return this