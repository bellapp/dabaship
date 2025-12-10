const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

const categories = [
  { id: 'plaisirs_sucres', name: 'Plaisirs Sucrés' },
  { id: 'soif', name: 'Soif' },
  { id: 'sale_rapide', name: 'Salé Rapide' },
  { id: 'epicerie', name: 'Épicerie' }
];

const products = [
  // Beverages (Soif)
  {
    name: 'Coca-Cola 1.5L',
    price: 12,
    image_url: 'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=400&h=400&fit=crop',
    category_id: 'soif',
    description: 'Coca-Cola classique 1.5 litres',
    is_available: true
  },
  {
    name: 'Eau Minérale Sidi Ali 1.5L',
    price: 5,
    image_url: 'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=400&h=400&fit=crop',
    category_id: 'soif',
    description: 'Eau minérale naturelle',
    is_available: true
  },
  {
    name: 'Jus d\'Orange Tropicana 1L',
    price: 18,
    image_url: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400&h=400&fit=crop',
    category_id: 'soif',
    description: 'Jus d\'orange 100% pur',
    is_available: true
  },
  {
    name: 'Raïbi Jamila Nature',
    price: 3,
    image_url: 'https://images.unsplash.com/photo-1628088062854-d1870b4553da?w=400&h=400&fit=crop',
    category_id: 'soif',
    description: 'Yaourt à boire marocain',
    is_available: true
  },
  {
    name: 'Café Nescafé Gold 200g',
    price: 65,
    image_url: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400&h=400&fit=crop',
    category_id: 'soif',
    description: 'Café soluble premium',
    is_available: true
  },
  {
    name: 'Thé Vert Sultan',
    price: 25,
    image_url: 'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=400&h=400&fit=crop',
    category_id: 'soif',
    description: 'Thé vert traditionnel marocain',
    is_available: true
  },

  // Snacks & Fast Food (Salé Rapide)
  {
    name: 'Sandwich Thon-Hrissa',
    price: 15,
    image_url: 'https://images.unsplash.com/photo-1553909489-cd47e0907980?w=400&h=400&fit=crop',
    category_id: 'sale_rapide',
    description: 'Sandwich thon piquant',
    is_available: true
  },
  {
    name: 'Pizza Margherita',
    price: 35,
    image_url: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&h=400&fit=crop',
    category_id: 'sale_rapide',
    description: 'Pizza classique italienne',
    is_available: true
  },
  {
    name: 'Chips Bimo Paprika',
    price: 8,
    image_url: 'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=400&h=400&fit=crop',
    category_id: 'sale_rapide',
    description: 'Chips saveur paprika',
    is_available: true
  },
  {
    name: 'Croissant au Beurre',
    price: 4,
    image_url: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400&h=400&fit=crop',
    category_id: 'sale_rapide',
    description: 'Croissant frais',
    is_available: true
  },

  // Sweets (Plaisirs Sucrés)
  {
    name: 'Mille-feuille',
    price: 5,
    image_url: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400&h=400&fit=crop',
    category_id: 'plaisirs_sucres',
    description: 'Pâtisserie française classique',
    is_available: true
  },
  {
    name: 'Merendina Cacao',
    price: 2,
    image_url: 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=400&h=400&fit=crop',
    category_id: 'plaisirs_sucres',
    description: 'Génoise fourrée au cacao',
    is_available: true
  },
  {
    name: 'Chocolat Milka 100g',
    price: 12,
    image_url: 'https://images.unsplash.com/photo-1511381939415-e44015466834?w=400&h=400&fit=crop',
    category_id: 'plaisirs_sucres',
    description: 'Chocolat au lait',
    is_available: true
  },
  {
    name: 'Baklava Marocain',
    price: 20,
    image_url: 'https://images.unsplash.com/photo-1519676867240-f03562e64548?w=400&h=400&fit=crop',
    category_id: 'plaisirs_sucres',
    description: 'Pâtisserie orientale au miel',
    is_available: true
  },
  {
    name: 'Biscuits Bimo Chocolat',
    price: 6,
    image_url: 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=400&h=400&fit=crop',
    category_id: 'plaisirs_sucres',
    description: 'Biscuits fourrés chocolat',
    is_available: true
  },

  // Grocery (Épicerie)
  {
    name: 'Huile d\'Olive Lesieur 1L',
    price: 45,
    image_url: 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400&h=400&fit=crop',
    category_id: 'epicerie',
    description: 'Huile d\'olive extra vierge',
    is_available: true
  },
  {
    name: 'Riz Basmati 1kg',
    price: 22,
    image_url: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&h=400&fit=crop',
    category_id: 'epicerie',
    description: 'Riz basmati premium',
    is_available: true
  },
  {
    name: 'Pâtes Barilla 500g',
    price: 15,
    image_url: 'https://images.unsplash.com/photo-1551462147-37d3a1b8e4a8?w=400&h=400&fit=crop',
    category_id: 'epicerie',
    description: 'Pâtes italiennes',
    is_available: true
  },
  {
    name: 'Lait Centrale 1L',
    price: 8,
    image_url: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&h=400&fit=crop',
    category_id: 'epicerie',
    description: 'Lait frais pasteurisé',
    is_available: true
  },
  {
    name: 'Pain de Mie',
    price: 7,
    image_url: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&h=400&fit=crop',
    category_id: 'epicerie',
    description: 'Pain de mie tranché',
    is_available: true
  }
];

async function populate() {
  const batch = db.batch();

  // Add Categories
  for (const cat of categories) {
    const ref = db.collection('categories').doc(cat.id);
    batch.set(ref, cat);
  }

  // Add Products
  for (const prod of products) {
    const ref = db.collection('products').doc(); // Auto-ID
    batch.set(ref, prod);
  }

  await batch.commit();
  console.log(`Successfully added ${categories.length} categories and ${products.length} products!`);
  console.log('\nCategories:');
  categories.forEach(c => console.log(`- ${c.name}`));
  console.log(`\nSample products:`);
  products.slice(0, 5).forEach(p => console.log(`- ${p.name}: ${p.price} MAD`));
}

populate().catch(console.error);
