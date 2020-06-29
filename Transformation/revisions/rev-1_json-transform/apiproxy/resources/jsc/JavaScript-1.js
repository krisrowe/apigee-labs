// Get the array of products from the service response.
var products = context.proxyResponse.content.asJSON.products;
// Loop through each product and standardize the format.
for (i = 0; i < products.length; i++) {
  products[i].price = products[i].priceUsd; // add price attribute
  delete products[i].priceUsd; // remove priceUsd attribute
  products[i].currency = "USD"; // add currency attribute 
}
// Remove the outer object named 'products' and make
// the array the root in the final response.
context.proxyResponse.content.asJSON = products;