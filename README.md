




Auto zoom to 70% (front camera) | Auto zoom to 46% (Back camera) | Auto zoom to 40% (Back camera)
:-: | :-: | :-: |
<video src='https://user-images.githubusercontent.com/90468365/225999133-33abfd7f-7de3-4995-a9ce-0992335b8c13.mp4 ' width=120/> | <video src='https://user-images.githubusercontent.com/90468365/225999216-601ed255-a547-4e11-95c6-e1261ce68e44.mp4' width=120/> | <video src='https://user-images.githubusercontent.com/90468365/225999351-f1daa75e-fb5c-498d-8de8-0857de8a918b.mp4' width=120/>







# autozoom (Real Time Zoom to a detected object)
- Face detection using google_mlkit_face_detection package
- Camera control using camera package
- Zoom is based on each previous frame to increase accuracy
- After each frame zoom level is getting calculated and passed to a zoom controller.

## App Flow
- Turn on the camera services
- Detect face
- Pass detected faces to the zoom calculator continuously 
- Calculate required zoom level
- Update the streaming screen using camera controller

