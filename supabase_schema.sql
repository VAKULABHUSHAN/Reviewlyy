-- ============================================================
-- ReviewHub: Complete Supabase PostgreSQL Schema
-- Production-ready, scalable, and optimized
-- ============================================================

-- ============================================================
-- 1. PROFILES TABLE (extends auth.users)
-- ============================================================
CREATE TABLE public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT NOT NULL DEFAULT '',
  email TEXT NOT NULL DEFAULT '',
  bio TEXT DEFAULT '',
  location TEXT DEFAULT '',
  avatar_url TEXT DEFAULT '',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_profiles_email ON public.profiles(email);

-- Auto-create profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, email)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    NEW.email
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- Auto-update updated_at
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();

-- RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Profiles are viewable by everyone"
  ON public.profiles FOR SELECT
  USING (true);

CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);


-- ============================================================
-- 2. CATEGORIES TABLE
-- ============================================================
CREATE TABLE public.categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  description TEXT DEFAULT '',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_categories_name ON public.categories(name);

ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Categories are viewable by everyone"
  ON public.categories FOR SELECT
  USING (true);

-- Only admins insert/update categories (via service role key or dashboard)


-- ============================================================
-- 3. PRODUCTS TABLE
-- ============================================================
CREATE TABLE public.products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT DEFAULT '',
  price NUMERIC(10, 2) NOT NULL DEFAULT 0,
  image_url TEXT DEFAULT '',
  category_id UUID REFERENCES public.categories(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_products_category ON public.products(category_id);
CREATE INDEX idx_products_title ON public.products(title);

ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Products are viewable by everyone"
  ON public.products FOR SELECT
  USING (true);


-- ============================================================
-- 4. REVIEWS TABLE
-- ============================================================
CREATE TABLE public.reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  title TEXT NOT NULL DEFAULT '',
  body TEXT NOT NULL DEFAULT '',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_reviews_product ON public.reviews(product_id);
CREATE INDEX idx_reviews_user ON public.reviews(user_id);
CREATE INDEX idx_reviews_rating ON public.reviews(rating);
CREATE INDEX idx_reviews_created_at ON public.reviews(created_at DESC);

CREATE TRIGGER reviews_updated_at
  BEFORE UPDATE ON public.reviews
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();

ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Reviews are viewable by everyone"
  ON public.reviews FOR SELECT
  USING (true);

CREATE POLICY "Authenticated users can create reviews"
  ON public.reviews FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own reviews"
  ON public.reviews FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own reviews"
  ON public.reviews FOR DELETE
  USING (auth.uid() = user_id);


-- ============================================================
-- 5. REVIEW_IMAGES TABLE
-- ============================================================
CREATE TABLE public.review_images (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  review_id UUID NOT NULL REFERENCES public.reviews(id) ON DELETE CASCADE,
  image_url TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_review_images_review ON public.review_images(review_id);

ALTER TABLE public.review_images ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Review images are viewable by everyone"
  ON public.review_images FOR SELECT
  USING (true);

CREATE POLICY "Users can insert images for own reviews"
  ON public.review_images FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.reviews
      WHERE reviews.id = review_id
      AND reviews.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete images from own reviews"
  ON public.review_images FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.reviews
      WHERE reviews.id = review_id
      AND reviews.user_id = auth.uid()
    )
  );


-- ============================================================
-- 6. REVIEW_VOTES TABLE (helpful votes)
-- ============================================================
CREATE TABLE public.review_votes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  review_id UUID NOT NULL REFERENCES public.reviews(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(review_id, user_id)
);

CREATE INDEX idx_review_votes_review ON public.review_votes(review_id);
CREATE INDEX idx_review_votes_user ON public.review_votes(user_id);

ALTER TABLE public.review_votes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Votes are viewable by everyone"
  ON public.review_votes FOR SELECT
  USING (true);

CREATE POLICY "Authenticated users can vote"
  ON public.review_votes FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can remove own votes"
  ON public.review_votes FOR DELETE
  USING (auth.uid() = user_id);


-- ============================================================
-- 7. USEFUL VIEWS (for dashboard aggregations)
-- ============================================================
CREATE OR REPLACE VIEW public.product_stats AS
SELECT
  p.id AS product_id,
  p.title,
  COUNT(r.id) AS review_count,
  COALESCE(AVG(r.rating), 0) AS average_rating
FROM public.products p
LEFT JOIN public.reviews r ON r.product_id = p.id
GROUP BY p.id, p.title;


-- ============================================================
-- 8. SEED DATA (categories + sample products)
-- ============================================================
INSERT INTO public.categories (id, name, description) VALUES
  ('a1b2c3d4-0001-4000-8000-000000000001', 'Electronics', 'Gadgets, headphones, and tech accessories'),
  ('a1b2c3d4-0002-4000-8000-000000000002', 'Accessories', 'Watches, wallets, and fashion accessories'),
  ('a1b2c3d4-0003-4000-8000-000000000003', 'Footwear', 'Shoes, trainers, and boots'),
  ('a1b2c3d4-0004-4000-8000-000000000004', 'Tech', 'Laptops, tablets, and computing devices');

INSERT INTO public.products (id, title, description, price, image_url, category_id) VALUES
  (
    'b1b2c3d4-0001-4000-8000-000000000001',
    'Pro Audio Gen-2',
    'Noise-cancelling wireless headphones with 40-hour battery life and spatial audio support.',
    299,
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBnh6NNvw0ublTnYkUqAsA-pT27xv1RXAn9JSe2ncgXuhoH-Z2wksSVzYmqrjsfResSfzcYL-T5mSsizKB_JyK9XjTWXSW5WFmXy1MiaKcPijZHNS-oM8yi-Y15i-Z90AuM9PVLznDIlATuhIxjBcMpPWm1xzNIHeY6Cnh0QXxKSW-rK3ta49yaWi36ihtoR8RorwZNbDbXg0IgIxwS6jBh_CYuCqDb3hJi1fk61SenTDCsO7o7EFYpo-UjrgsXVxFtD9Kf3i9uh2s',
    'a1b2c3d4-0001-4000-8000-000000000001'
  ),
  (
    'b1b2c3d4-0002-4000-8000-000000000002',
    'Lunar Minimalist Watch',
    'A timeless piece featuring sapphire glass and an Italian leather strap for everyday elegance.',
    185,
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBV2eiSjxRs4HEkLnKWr3z4nDULdGDHijArCK1cWRWWfExFeirRAWeiJFxIkqHns4QjydJWRxNW6tGYW2tNdOuvw-3ZOmgZ9Zflohz4UkbTO0EyCpdO_Y1xRKeQvVVb5AIFc8kcSkK6I8VdmmWSRV-szCFQNImgIygqkfk172PpzcAnK88wp4rnYkotzlheDhBLzXqxRtUQQljqTu9W4Q-3jlxHIkJ-JfCIgwakuUYOc9my9jyfDmTghfkTHBvQkJPkP_0dbwDa550',
    'a1b2c3d4-0002-4000-8000-000000000002'
  ),
  (
    'b1b2c3d4-0003-4000-8000-000000000003',
    'Velo Sprint Trainers',
    'Ultra-lightweight performance shoes designed for both professional athletes and daily runners.',
    140,
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCmmoCLCY-P6NdCLmRMBK83dCmo8CSjgW76Lbqne9c6b1yKXmOswCZDRvtYvsbfjuwpFiblN2q8cVpa8_ze1zUD51khonT5qGbR2-lEGwAyKkZKSjo5_49URYTOTFJ26MTwAapYE6GzhiaBzmTI3HX-_PZqHeTVmQUwMB5Sd_6Toakv7zfcDTLYiP26cLTixIZiWAMswRfgSdWfAiXGbV2QHbFVi7ssI_AwQJYRcXL8dnPaEklX8FpgDJo9-9yelenDSmSDRdtQCOY',
    'a1b2c3d4-0003-4000-8000-000000000003'
  ),
  (
    'b1b2c3d4-0004-4000-8000-000000000004',
    'NovaBook 14 Air',
    'Ultra-portable laptop with 4K OLED display and the latest high-efficiency processor.',
    1199,
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAxVvzSRjUcjYH25z4Glihf5ZZgmkcgtmf7Mglc84cu40wJwHbbVA8IeqXG0z_IXJN46DNZ6pqIA1lGAdpoEHXo-vE-60V-G_JwlztbP6X2Opz21adsQrIKrGXPopoKdx-EAoZ1cfQ_0dN8lmhzra_kVcqCTjCbJJcPAQSevPqIdASIoj5rRH1PfEG1_ckX6DdZcXg4v02f5zVHlQm9NTakbhbLjYzmM3OIexrfeipWqLdedmfxdWlWP5BODJfePv3_qtj3CxOt4Ng',
    'a1b2c3d4-0004-4000-8000-000000000004'
  );


-- ============================================================
-- 9. STORAGE BUCKETS (run in Supabase Dashboard > Storage)
-- ============================================================
-- These must be created via Supabase Dashboard or API:
--
-- Bucket: avatars    (public: true)
-- Bucket: products   (public: true)
-- Bucket: reviews    (public: true)
--
-- Storage policies (SQL):

-- AVATARS BUCKET
INSERT INTO storage.buckets (id, name, public) VALUES ('avatars', 'avatars', true)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "Avatar images are publicly accessible"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'avatars');

CREATE POLICY "Users can upload their own avatar"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'avatars'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Users can update their own avatar"
  ON storage.objects FOR UPDATE
  USING (
    bucket_id = 'avatars'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Users can delete their own avatar"
  ON storage.objects FOR DELETE
  USING (
    bucket_id = 'avatars'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

-- PRODUCTS BUCKET
INSERT INTO storage.buckets (id, name, public) VALUES ('products', 'products', true)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "Product images are publicly accessible"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'products');

-- REVIEWS BUCKET
INSERT INTO storage.buckets (id, name, public) VALUES ('reviews', 'reviews', true)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "Review images are publicly accessible"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'reviews');

CREATE POLICY "Users can upload review images"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'reviews'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Users can delete own review images"
  ON storage.objects FOR DELETE
  USING (
    bucket_id = 'reviews'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );


-- ============================================================
-- 10. EXAMPLE INSERT QUERIES
-- ============================================================
-- Insert a review (after auth):
-- INSERT INTO public.reviews (product_id, user_id, rating, title, body)
-- VALUES ('b1b2c3d4-0001-4000-8000-000000000001', auth.uid(), 5, 'Amazing!', 'Best headphones ever.');

-- Insert review image:
-- INSERT INTO public.review_images (review_id, image_url)
-- VALUES ('<review-uuid>', 'https://your-supabase-url.supabase.co/storage/v1/object/public/reviews/user-id/image.jpg');

-- Toggle helpful vote:
-- INSERT INTO public.review_votes (review_id, user_id) VALUES ('<review-uuid>', auth.uid())
-- ON CONFLICT (review_id, user_id) DO NOTHING;
-- or DELETE FROM public.review_votes WHERE review_id = '<review-uuid>' AND user_id = auth.uid();
