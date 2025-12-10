const puppeteer = require('puppeteer');
const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

// Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function scrapeMarjane() {
  console.log('Launching browser...');
  const browser = await puppeteer.launch({ 
    headless: false,
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });
  
  const page = await browser.newPage();
  
  // Set user agent to avoid blocking
  await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36');
  
  try {
    console.log('Navigating to Marjane beverages...');
    await page.goto('https://www.marjane.ma/search/boisson', { 
      waitUntil: 'networkidle2',
      timeout: 60000 
    });
    
    console.log('Waiting for products to load...');
    // Wait a bit for dynamic content
    await page.waitForTimeout(3000);
    
    // Try multiple possible selectors
    const selectors = [
      '.product-item',
      '.product-card', 
      '[data-product]',
      '.product',
      'article',
      '.item',
      '[class*="product"]'
    ];
    
    let foundSelector = null;
    for (const selector of selectors) {
      const elements = await page.$$(selector);
      if (elements.length > 0) {
        console.log(`Found ${elements.length} elements with selector: ${selector}`);
        foundSelector = selector;
        break;
      }
    }
    
    // Extract product data
    const products = await page.evaluate(() => {
      const items = [];
      
      // Try different selectors for product containers
      const possibleSelectors = [
        '.product-item', 
        '.product-card', 
        '[data-product]',
        '.product',
        'article',
        '.item',
        '[class*="product"]'
      ];
      
      let productElements = [];
      for (const selector of possibleSelectors) {
        productElements = document.querySelectorAll(selector);
        if (productElements.length > 0) break;
      }
      
      console.log(`Processing ${productElements.length} product elements`);
      
      productElements.forEach((element, index) => {
        if (index >= 30) return; // Limit to 30 products
        
        try {
          // Try multiple selectors for name
          const nameSelectors = [
            '.product-name', 
            '.product-title', 
            'h3', 
            'h4', 
            'h2',
            '[class*="name"]',
            '[class*="title"]'
          ];
          let name = null;
          for (const sel of nameSelectors) {
            const el = element.querySelector(sel);
            if (el?.textContent?.trim()) {
              name = el.textContent.trim();
              break;
            }
          }
          
          // Try multiple selectors for price
          const priceSelectors = [
            '.price', 
            '.product-price', 
            '[class*="price"]',
            '[data-price]'
          ];
          let priceText = null;
          for (const sel of priceSelectors) {
            const el = element.querySelector(sel);
            if (el?.textContent?.trim()) {
              priceText = el.textContent.trim();
              break;
            }
          }
          
          // Get image
          const img = element.querySelector('img');
          const imageUrl = img?.src || img?.dataset?.src || img?.getAttribute('data-src');
          
          // Extract price number
          const price = priceText ? parseFloat(priceText.replace(/[^0-9.,]/g, '').replace(',', '.')) : 0;
          
          if (name && price > 0 && imageUrl) {
            items.push({
              name: name,
              price: price,
              image_url: imageUrl.startsWith('http') ? imageUrl : 'https://www.marjane.ma' + imageUrl,
              category_id: 'soif',
              description: name,
              is_available: true
            });
            console.log(`Found: ${name} - ${price} MAD`);
          }
        } catch (err) {
          console.error('Error parsing product:', err);
        }
      });
      
      return items;
    });
    
    console.log(`Found ${products.length} products`);
    
    if (products.length > 0) {
      // Save to Firestore
      const batch = db.batch();
      
      products.forEach(product => {
        const ref = db.collection('products').doc();
        batch.set(ref, product);
      });
      
      await batch.commit();
      console.log('Products saved to Firestore successfully!');
      
      // Print sample
      console.log('\nSample products:');
      products.slice(0, 3).forEach(p => {
        console.log(`- ${p.name}: ${p.price} MAD`);
      });
    } else {
      console.log('No products found. The website structure may have changed.');
      console.log('Taking screenshot for debugging...');
      await page.screenshot({ path: 'marjane-debug.png', fullPage: true });
    }
    
  } catch (error) {
    console.error('Error scraping:', error);
    await page.screenshot({ path: 'marjane-error.png', fullPage: true });
  } finally {
    await browser.close();
  }
}

scrapeMarjane().catch(console.error);
