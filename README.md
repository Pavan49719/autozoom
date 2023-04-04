




Auto zoom to 70% (front camera) | Auto zoom to 46% (Back camera) | Auto zoom to 40% (Back camera)
:-: | :-: | :-: |
<video src='https://user-images.githubusercontent.com/90468365/225999133-33abfd7f-7de3-4995-a9ce-0992335b8c13.mp4 ' width=120/> | <video src='https://user-images.githubusercontent.com/90468365/225999216-601ed255-a547-4e11-95c6-e1261ce68e44.mp4' width=120/> | <video src='https://user-images.githubusercontent.com/90468365/225999351-f1daa75e-fb5c-498d-8de8-0857de8a918b.mp4' width=120/>




## App Flow
- Turn on the camera services using camera package
- Detect face using google_mlkit_face_detection package
- Pass detected faces to the zoom calculator continuously
- Zoom is based on each previous frame to increase accuracy
- After each frame zoom level is getting calculated and passed to a camera controller.
- Update the streaming screen using camera controller

| Approach 1 | Approach 2 |
| --- | --- |
| Zoom value is based on each previous frame | Zoom value is based on the first detected frame |
| It calculates zoom value by comparing regionHeight and regionWidth with screenHeight and screenWidth | It calculates zoom value by a mathematical formula which involves, regionHeight, regionWidth, screenHeight, screenWidth |
| Zoom level is adjusted seamlessly even when the camera is moved forward or backward. Which ensures real time auto zoom adjustment feature. | Zoom level is adjusted with very less accuracy when the camera is moved. Real time auto zoom adjustment feature doesn't work well here. |
| This approach is also faster but not as of approach 2 because it involves continuous comparison for each new frame. | This approach is very faster in time because it involves mathematical formula |
| Accuracy is high for both nearer and distant objects. | Less accurate for nearer objects. |

### I preferred approach 1 because it gives real time features with more accuracy.




