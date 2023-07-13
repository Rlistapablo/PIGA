// Obtener el video y el botón de captura
const video = document.getElementById('video');
const captureBtn = document.getElementById('capture-btn');
const canvas = document.getElementById('canvas');
const canvasContext = canvas.getContext('2d');
const imageDataField = document.getElementById('image-data');

// Establecer el tamaño deseado para el lienzo y el video
const canvasWidth = 1200;
const canvasHeight = 1200;
canvas.width = canvasWidth;
canvas.height = canvasHeight;
video.width = canvasWidth;
video.height = canvasHeight;

// Acceder a la cámara y mostrar el flujo de video en el elemento <video>
navigator.mediaDevices.getUserMedia({ video: { facingMode: { exact: 'environment' }, width: canvasWidth, height: canvasHeight } })
  .then(stream => {
    video.srcObject = stream;
  })
  .catch(error => {
    console.error('Error al acceder a la cámara:', error);
  });

// Función para capturar la foto
function capturePhoto() {
  // Asegurarse de que el video esté pausado
  video.pause();

  // Dibujar el cuadro de video en el lienzo
  canvasContext.drawImage(video, 0, 0, canvas.width, canvas.height);

  // Convertir el lienzo a una imagen codificada en base64
  const imageData = canvas.toDataURL('image/jpeg');

  // Establecer el valor del campo oculto con la imagen capturada
  imageDataField.value = imageData;

  // Enviar el formulario al servidor
  document.getElementById('captura-form').submit();
}

// Agregar un event listener al botón de captura para llamar a la función capturePhoto() cuando se haga clic
captureBtn.addEventListener('click', capturePhoto);
