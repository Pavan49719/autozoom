Tiel |ssdf  | sdfs
:-------------------------:|:-------------------------:|:-------------------------:
<video src="[Video1](https://user-images.githubusercontent.com/90468365/225999133-33abfd7f-7de3-4995-a9ce-0992335b8c13.mp4)" width="100%" height="auto" controls></video> |  <video src="[Video2](https://user-images.githubusercontent.com/90468365/225999216-601ed255-a547-4e11-95c6-e1261ce68e44.mp4)" width="100%" height="auto" controls></video> | <video src="[Video3](https://user-images.githubusercontent.com/90468365/225999351-f1daa75e-fb5c-498d-8de8-0857de8a918b.mp4)" width="100%" height="auto" controls></video>

https://user-images.githubusercontent.com/90468365/225999133-33abfd7f-7de3-4995-a9ce-0992335b8c13.mp4 
https://user-images.githubusercontent.com/90468365/225999216-601ed255-a547-4e11-95c6-e1261ce68e44.mp4
https://user-images.githubusercontent.com/90468365/225999351-f1daa75e-fb5c-498d-8de8-0857de8a918b.mp4



<div style="display: flex; flex-wrap: wrap;">
  <div style="flex: 33.33%; padding: 5px;">
    <h3>Auto zoom to 70% (front camera) </h3>
    
  </div>
  <div style="flex: 33.33%; padding: 5px;">
    <h3>Auto zoom to 46% (Back camera) </h3>
    <video src="[Video2](https://user-images.githubusercontent.com/90468365/225999216-601ed255-a547-4e11-95c6-e1261ce68e44.mp4)" width="100%" height="auto" controls></video>
  </div>
  <div style="flex: 33.33%; padding: 5px;">
    <h3>Auto zoom to 40% (Back camera) </h3>
    <video src="[Video3](https://user-images.githubusercontent.com/90468365/225999351-f1daa75e-fb5c-498d-8de8-0857de8a918b.mp4)" width="100%" height="auto" controls></video>
  </div>
</div>







# autozoom (Real Time Zoom to a detected object)
- Face detection using google_mlkit_face_detection package
- Camera control using camera package

## App Flow
- Turn on the camera services
- Detect face
- Pass detected faces to the zoom calculator continuously 
- Calculate required zoom level
- Update the streaming screen using camera controller

