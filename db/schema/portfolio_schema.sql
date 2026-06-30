-- ============================================================
--  PORTFOLIO CMS — Full MySQL Schema
--  Multilingual: Arabic (ar) | French (fr) | English (en)
--  Analysed from: landing_page, projects, project_details,
--                 blogs, blog_details templates
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;


-- ============================================================
-- 1. SITE SETTINGS
--    Global config: logo, favicon, theme defaults, SEO
-- ============================================================
CREATE TABLE site_settings (
    id            TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    logo_text     VARCHAR(10)  NOT NULL DEFAULT 'OJ.',          -- "OJ." top-left brand mark
    favicon_url   VARCHAR(500),
    cv_url        VARCHAR(500),                                  -- Download CV button
    theme_default ENUM('dark','light') NOT NULL DEFAULT 'dark',
    lang_default  ENUM('ar','fr','en') NOT NULL DEFAULT 'en',
    -- SEO meta (per language)
    meta_title_en      VARCHAR(160),
    meta_title_fr      VARCHAR(160),
    meta_title_ar      VARCHAR(160),
    meta_description_en VARCHAR(320),
    meta_description_fr VARCHAR(320),
    meta_description_ar VARCHAR(320),
    -- Footer
    footer_copy_en VARCHAR(255) DEFAULT '© 2025 All rights reserved.',
    footer_copy_fr VARCHAR(255),
    footer_copy_ar VARCHAR(255),
    updated_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 2. HERO SECTION  (landing page — top fold)
--    "Hello, I'm / Oussema Jbeli / Full-Stack Developer"
-- ============================================================
CREATE TABLE hero (
    id                  TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    -- Role badge  e.g. "> FULL-STACK DEVELOPER"
    badge_en            VARCHAR(100),
    badge_fr            VARCHAR(100),
    badge_ar            VARCHAR(100),
    -- Greeting line  e.g. "Hello, I'm"
    greeting_en         VARCHAR(100),
    greeting_fr         VARCHAR(100),
    greeting_ar         VARCHAR(100),
    -- Full name (usually not translated, but kept flexible)
    full_name           VARCHAR(120) NOT NULL,
    -- Animated typewriter strings (JSON array, same for all langs or per-lang)
    typewriter_en       JSON COMMENT '["I build modern...", "I design..."]',
    typewriter_fr       JSON,
    typewriter_ar       JSON,
    -- Tagline / short description under the name
    tagline_en          VARCHAR(500),
    tagline_fr          VARCHAR(500),
    tagline_ar          VARCHAR(500),
    -- Hero photo
    photo_url           VARCHAR(500),
    -- CTA buttons
    cta_primary_label_en    VARCHAR(80)  DEFAULT 'Download CV',
    cta_primary_label_fr    VARCHAR(80)  DEFAULT 'Télécharger CV',
    cta_primary_label_ar    VARCHAR(80)  DEFAULT 'تحميل السيرة الذاتية',
    cta_primary_url         VARCHAR(500),                        -- links to cv_url or custom
    cta_secondary_label_en  VARCHAR(80)  DEFAULT 'View My Works',
    cta_secondary_label_fr  VARCHAR(80)  DEFAULT 'Voir mes travaux',
    cta_secondary_label_ar  VARCHAR(80)  DEFAULT 'عرض أعمالي',
    cta_secondary_url        VARCHAR(500),
    -- Floating code badge  e.g. "</>"
    code_badge          VARCHAR(20)  DEFAULT '</>',
    updated_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 3. SOCIAL LINKS
--    Shared across Hero, Blog Author card, Footer, About
-- ============================================================
CREATE TABLE social_links (
    id           SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    platform     VARCHAR(50)  NOT NULL,          -- 'linkedin','github','twitter','behance'
    url          VARCHAR(500) NOT NULL,
    icon_class   VARCHAR(100),                    -- e.g. 'fab fa-linkedin' or SVG key
    display_in   SET('hero','about','footer','blog_author') NOT NULL DEFAULT 'hero,footer',
    sort_order   TINYINT UNSIGNED NOT NULL DEFAULT 0,
    is_active    TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 4. STATS  (counter badges: 50+ Projects, 30+ Clients …)
--    Appear on: Hero bottom bar, Projects listing footer
-- ============================================================
CREATE TABLE stats (
    id           SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    value        VARCHAR(20) NOT NULL,            -- "50+", "100%", "3+"
    icon_class   VARCHAR(100),
    label_en     VARCHAR(100) NOT NULL,
    label_fr     VARCHAR(100),
    label_ar     VARCHAR(100),
    sort_order   TINYINT UNSIGNED NOT NULL DEFAULT 0,
    is_active    TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 5. ABOUT SECTION
--    "About Me" — bio, bullet points, personal info card
-- ============================================================
CREATE TABLE about (
    id                  TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    -- Section heading
    section_badge_en    VARCHAR(80)  DEFAULT '> ABOUT ME',
    section_badge_fr    VARCHAR(80)  DEFAULT '> À PROPOS',
    section_badge_ar    VARCHAR(80)  DEFAULT '> عني',
    heading_en          VARCHAR(160) DEFAULT 'About Me',
    heading_fr          VARCHAR(160) DEFAULT 'À propos de moi',
    heading_ar          VARCHAR(160) DEFAULT 'عني',
    -- Main bio paragraph
    bio_en              TEXT,
    bio_fr              TEXT,
    bio_ar              TEXT,
    -- Photo (side image in about section)
    photo_url           VARCHAR(500),
    -- Info card fields
    display_name        VARCHAR(120),             -- "Oussema Jbeli"  (rarely translated)
    email               VARCHAR(255),
    location_en         VARCHAR(120),
    location_fr         VARCHAR(120),
    location_ar         VARCHAR(120),
    availability_en     VARCHAR(120)  DEFAULT 'Freelance / Full-time',
    availability_fr     VARCHAR(120)  DEFAULT 'Freelance / Temps plein',
    availability_ar     VARCHAR(120)  DEFAULT 'عمل حر / دوام كامل',
    -- CTA button
    cta_label_en        VARCHAR(80)   DEFAULT "Let's Talk",
    cta_label_fr        VARCHAR(80)   DEFAULT 'Contactez-moi',
    cta_label_ar        VARCHAR(80)   DEFAULT 'تواصل معي',
    cta_url             VARCHAR(500),
    updated_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 6. ABOUT BULLET POINTS
--    "3+ Years experience", "Specialized in Laravel…" etc.
-- ============================================================
CREATE TABLE about_bullets (
    id           SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    icon_class   VARCHAR(100),
    text_en      VARCHAR(255) NOT NULL,
    text_fr      VARCHAR(255),
    text_ar      VARCHAR(255),
    sort_order   TINYINT UNSIGNED NOT NULL DEFAULT 0,
    is_active    TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 7. SKILL CATEGORIES
--    Left column progress bars: "Frontend Development 90%"
-- ============================================================
CREATE TABLE skill_categories (
    id           SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name_en      VARCHAR(120) NOT NULL,
    name_fr      VARCHAR(120),
    name_ar      VARCHAR(120),
    percentage   TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0-100',
    sort_order   TINYINT UNSIGNED NOT NULL DEFAULT 0,
    is_active    TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 8. TECHNOLOGIES / TECH ICONS
--    Right grid icons: Vue.js, React, Laravel, Docker, AWS…
--    Also reused as tech-stack badges on project cards
-- ============================================================
CREATE TABLE technologies (
    id           SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name         VARCHAR(80)  NOT NULL,           -- "Vue.js", "Laravel"
    icon_url     VARCHAR(500),                     -- SVG/PNG path
    icon_class   VARCHAR(100),                     -- alternative: devicon class
    color        VARCHAR(7),                       -- hex, e.g. "#42B883"
    PRIMARY KEY (id),
    UNIQUE KEY uq_tech_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 9. SKILLS SECTION CONFIG
--    Section-level heading + badge (the "My Skills" heading)
-- ============================================================
CREATE TABLE skills_section (
    id                  TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    section_badge_en    VARCHAR(80)  DEFAULT '> SKILLS',
    section_badge_fr    VARCHAR(80)  DEFAULT '> COMPÉTENCES',
    section_badge_ar    VARCHAR(80)  DEFAULT '> المهارات',
    heading_en          VARCHAR(160) DEFAULT 'My Skills',
    heading_fr          VARCHAR(160) DEFAULT 'Mes compétences',
    heading_ar          VARCHAR(160) DEFAULT 'مهاراتي',
    updated_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 10. PROJECT CATEGORIES  (filter tabs on listing page)
--     "All", "Web Applications", "E-Commerce", "AI/ML"…
-- ============================================================
CREATE TABLE project_categories (
    id           SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    slug         VARCHAR(80)  NOT NULL,
    name_en      VARCHAR(100) NOT NULL,
    name_fr      VARCHAR(100),
    name_ar      VARCHAR(100),
    sort_order   TINYINT UNSIGNED NOT NULL DEFAULT 0,
    is_active    TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    UNIQUE KEY uq_project_cat_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 11. PROJECTS
--     Listing card + full detail page
-- ============================================================
CREATE TABLE projects (
    id                  INT UNSIGNED NOT NULL AUTO_INCREMENT,
    slug                VARCHAR(200) NOT NULL,
    category_id         SMALLINT UNSIGNED,
    -- Listing page fields
    thumbnail_url       VARCHAR(500),
    is_featured         TINYINT(1) NOT NULL DEFAULT 0,
    is_active           TINYINT(1) NOT NULL DEFAULT 1,
    sort_order          SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    -- Detail page — hero area
    title_en            VARCHAR(200) NOT NULL,
    title_fr            VARCHAR(200),
    title_ar            VARCHAR(200),
    subtitle_en         VARCHAR(300),              -- "A Productivity Web Application"
    subtitle_fr         VARCHAR(300),
    subtitle_ar         VARCHAR(300),
    -- Short description (used on listing card + detail hero)
    description_en      TEXT,
    description_fr      TEXT,
    description_ar      TEXT,
    -- "About the Project" section (detail page, longer text)
    about_en            TEXT,
    about_fr            TEXT,
    about_ar            TEXT,
    -- Hero / banner image (detail page, large screenshot)
    hero_image_url      VARCHAR(500),
    -- Project Info sidebar
    client_en           VARCHAR(200),              -- "Personal Project", "Client Name"
    client_fr           VARCHAR(200),
    client_ar           VARCHAR(200),
    duration_en         VARCHAR(100),              -- "3 Weeks"
    duration_fr         VARCHAR(100),
    duration_ar         VARCHAR(100),
    completed_date      DATE,
    -- CTA links
    live_demo_url       VARCHAR(500),
    github_url          VARCHAR(500),
    -- Timestamps
    created_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_project_slug (slug),
    CONSTRAINT fk_project_category
        FOREIGN KEY (category_id) REFERENCES project_categories(id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 12. PROJECT GALLERY IMAGES
--     Carousel on detail page
-- ============================================================
CREATE TABLE project_gallery (
    id           INT UNSIGNED NOT NULL AUTO_INCREMENT,
    project_id   INT UNSIGNED NOT NULL,
    image_url    VARCHAR(500) NOT NULL,
    alt_en       VARCHAR(255),
    alt_fr       VARCHAR(255),
    alt_ar       VARCHAR(255),
    sort_order   TINYINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    CONSTRAINT fk_gallery_project
        FOREIGN KEY (project_id) REFERENCES projects(id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 13. PROJECT FEATURES  (bullet checklist — "About the Project")
--     "✓ Create and manage tasks with ease"
-- ============================================================
CREATE TABLE project_features (
    id           INT UNSIGNED NOT NULL AUTO_INCREMENT,
    project_id   INT UNSIGNED NOT NULL,
    text_en      VARCHAR(500) NOT NULL,
    text_fr      VARCHAR(500),
    text_ar      VARCHAR(500),
    sort_order   TINYINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    CONSTRAINT fk_feature_project
        FOREIGN KEY (project_id) REFERENCES projects(id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 14. PROJECT TECHNOLOGIES  (many-to-many)
--     Tech stack badges shown on card + detail page
-- ============================================================
CREATE TABLE project_technologies (
    project_id      INT UNSIGNED NOT NULL,
    technology_id   SMALLINT UNSIGNED NOT NULL,
    sort_order      TINYINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (project_id, technology_id),
    CONSTRAINT fk_pt_project
        FOREIGN KEY (project_id) REFERENCES projects(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_pt_technology
        FOREIGN KEY (technology_id) REFERENCES technologies(id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 15. PROJECT ROLES  ("What I Did" cards on detail page)
--     e.g. "Frontend Development — Built the responsive UI…"
-- ============================================================
CREATE TABLE project_roles (
    id           INT UNSIGNED NOT NULL AUTO_INCREMENT,
    project_id   INT UNSIGNED NOT NULL,
    icon_class   VARCHAR(100),                    -- e.g. '</>' , stack icon
    title_en     VARCHAR(150) NOT NULL,
    title_fr     VARCHAR(150),
    title_ar     VARCHAR(150),
    body_en      TEXT,
    body_fr      TEXT,
    body_ar      TEXT,
    sort_order   TINYINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    CONSTRAINT fk_role_project
        FOREIGN KEY (project_id) REFERENCES projects(id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 16. PROJECTS SECTION CONFIG  (landing page section heading)
-- ============================================================
CREATE TABLE projects_section (
    id                  TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    section_badge_en    VARCHAR(80)  DEFAULT '> PROJECTS',
    section_badge_fr    VARCHAR(80)  DEFAULT '> PROJETS',
    section_badge_ar    VARCHAR(80)  DEFAULT '> المشاريع',
    heading_part1_en    VARCHAR(160) DEFAULT 'My Projects',
    heading_part1_fr    VARCHAR(160) DEFAULT 'Mes Projets',
    heading_part1_ar    VARCHAR(160) DEFAULT 'مشاريعي',
    subheading_en       VARCHAR(500),
    subheading_fr       VARCHAR(500),
    subheading_ar       VARCHAR(500),
    -- Projects listing page hero
    listing_title_part1_en    VARCHAR(160) DEFAULT "Things I've",
    listing_title_part1_fr    VARCHAR(160) DEFAULT 'Ce que j ai',
    listing_title_part1_ar    VARCHAR(160) DEFAULT 'ما قمت',
    listing_title_part2_en    VARCHAR(160) DEFAULT 'Built',
    listing_title_part2_fr    VARCHAR(160) DEFAULT 'Construit',
    listing_title_part2_ar    VARCHAR(160) DEFAULT 'ببنائه',
    listing_subtitle_en       VARCHAR(500),
    listing_subtitle_fr       VARCHAR(500),
    listing_subtitle_ar       VARCHAR(500),
    -- CTA
    cta_label_en        VARCHAR(80)  DEFAULT 'View All Projects',
    cta_label_fr        VARCHAR(80)  DEFAULT 'Voir tous les projets',
    cta_label_ar        VARCHAR(80)  DEFAULT 'عرض كل المشاريع',
    updated_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 17. BLOG CATEGORIES  (tag filter tabs on listing page)
--     "All", "Laravel", "Vue", "Node.js", "AI", "DevOps"…
-- ============================================================
CREATE TABLE blog_categories (
    id           SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    slug         VARCHAR(80)  NOT NULL,
    name_en      VARCHAR(100) NOT NULL,
    name_fr      VARCHAR(100),
    name_ar      VARCHAR(100),
    sort_order   TINYINT UNSIGNED NOT NULL DEFAULT 0,
    is_active    TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    UNIQUE KEY uq_blog_cat_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 18. BLOGS
--     Listing card + full detail page
-- ============================================================
CREATE TABLE blogs (
    id                  INT UNSIGNED NOT NULL AUTO_INCREMENT,
    slug                VARCHAR(300) NOT NULL,
    -- Core content (all translatable)
    title_en            VARCHAR(300) NOT NULL,
    title_fr            VARCHAR(300),
    title_ar            VARCHAR(300),
    excerpt_en          TEXT COMMENT 'Short description shown on listing cards',
    excerpt_fr          TEXT,
    excerpt_ar          TEXT,
    body_en             LONGTEXT COMMENT 'Full HTML/Markdown article body',
    body_fr             LONGTEXT,
    body_ar             LONGTEXT,
    -- Media
    cover_image_url     VARCHAR(500),
    -- Meta
    read_time_minutes   TINYINT UNSIGNED,          -- "10 min read"
    views               INT UNSIGNED NOT NULL DEFAULT 0,
    is_featured         TINYINT(1) NOT NULL DEFAULT 0,
    is_active           TINYINT(1) NOT NULL DEFAULT 1,
    published_at        DATETIME,
    created_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_blog_slug (slug),
    INDEX idx_blog_published (published_at),
    INDEX idx_blog_featured (is_featured)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 19. BLOG ↔ CATEGORY  (many-to-many)
--     A post can carry multiple tags: "AI", "OpenSearch", "Laravel"
-- ============================================================
CREATE TABLE blog_category_map (
    blog_id         INT UNSIGNED NOT NULL,
    category_id     SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY (blog_id, category_id),
    CONSTRAINT fk_bcm_blog
        FOREIGN KEY (blog_id) REFERENCES blogs(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_bcm_category
        FOREIGN KEY (category_id) REFERENCES blog_categories(id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 20. BLOG TABLE OF CONTENTS
--     Left sidebar anchors on detail page
--     "Introduction / Why I Built This / Tech Stack…"
-- ============================================================
CREATE TABLE blog_toc (
    id           INT UNSIGNED NOT NULL AUTO_INCREMENT,
    blog_id      INT UNSIGNED NOT NULL,
    anchor       VARCHAR(150) NOT NULL,            -- href="#introduction"
    label_en     VARCHAR(200) NOT NULL,
    label_fr     VARCHAR(200),
    label_ar     VARCHAR(200),
    sort_order   TINYINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    CONSTRAINT fk_toc_blog
        FOREIGN KEY (blog_id) REFERENCES blogs(id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 21. RELATED ARTICLES  (right sidebar on blog detail)
--     Explicit editorial picks (override algorithmic)
-- ============================================================
CREATE TABLE blog_related (
    blog_id         INT UNSIGNED NOT NULL COMMENT 'The main article',
    related_id      INT UNSIGNED NOT NULL COMMENT 'The suggested article',
    sort_order      TINYINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (blog_id, related_id),
    CONSTRAINT fk_br_blog
        FOREIGN KEY (blog_id) REFERENCES blogs(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_br_related
        FOREIGN KEY (related_id) REFERENCES blogs(id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 22. BLOGS SECTION CONFIG  (landing page "Latest Blogs" heading)
-- ============================================================
CREATE TABLE blogs_section (
    id                  TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    section_badge_en    VARCHAR(80)  DEFAULT '> BLOGS',
    section_badge_fr    VARCHAR(80)  DEFAULT '> ARTICLES',
    section_badge_ar    VARCHAR(80)  DEFAULT '> المقالات',
    heading_part1_en    VARCHAR(160) DEFAULT 'Latest Blogs',
    heading_part1_fr    VARCHAR(160) DEFAULT 'Derniers Articles',
    heading_part1_ar    VARCHAR(160) DEFAULT 'أحدث المقالات',
    -- Listing page hero
    listing_badge_en    VARCHAR(80)  DEFAULT '> MY BLOGS',
    listing_badge_fr    VARCHAR(80)  DEFAULT '> MES ARTICLES',
    listing_badge_ar    VARCHAR(80)  DEFAULT '> مقالاتي',
    listing_title_part1_en    VARCHAR(160) DEFAULT 'Tech Insights',
    listing_title_part1_fr    VARCHAR(160) DEFAULT 'Aperçus Tech',
    listing_title_part1_ar    VARCHAR(160) DEFAULT 'رؤى تقنية',
    listing_title_part2_en    VARCHAR(160) DEFAULT 'Blogs & Tutorials.',
    listing_title_part2_fr    VARCHAR(160) DEFAULT 'Blogs et Tutoriels.',
    listing_title_part2_ar    VARCHAR(160) DEFAULT 'مدونات ودروس.',
    listing_subtitle_en       VARCHAR(500),
    listing_subtitle_fr       VARCHAR(500),
    listing_subtitle_ar       VARCHAR(500),
    -- CTA
    cta_label_en        VARCHAR(80)  DEFAULT 'View All Blogs',
    cta_label_fr        VARCHAR(80)  DEFAULT 'Voir tous les articles',
    cta_label_ar        VARCHAR(80)  DEFAULT 'عرض كل المقالات',
    updated_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 23. AUTHOR  (Blog detail — "About the Author" sidebar)
--     Single-author portfolio; keep as a table for flexibility
-- ============================================================
CREATE TABLE author (
    id              TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    full_name       VARCHAR(120) NOT NULL,
    photo_url       VARCHAR(500),
    role_en         VARCHAR(120),                  -- "Full-Stack Developer"
    role_fr         VARCHAR(120),
    role_ar         VARCHAR(120),
    bio_en          TEXT,
    bio_fr          TEXT,
    bio_ar          TEXT,
    profile_url     VARCHAR(500),                  -- "View Profile →" link
    updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 24. CONTACT SECTION
--     Left block: email, phone, location, availability
--     Right: contact form (form data handled in contacts_messages)
-- ============================================================
CREATE TABLE contact_section (
    id                  TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    section_badge_en    VARCHAR(80)  DEFAULT '> CONTACT',
    section_badge_fr    VARCHAR(80)  DEFAULT '> CONTACT',
    section_badge_ar    VARCHAR(80)  DEFAULT '> التواصل',
    heading_en          VARCHAR(160) DEFAULT 'Contact Me',
    heading_fr          VARCHAR(160) DEFAULT 'Contactez-moi',
    heading_ar          VARCHAR(160) DEFAULT 'تواصل معي',
    subtext_en          TEXT,
    subtext_fr          TEXT,
    subtext_ar          TEXT,
    email               VARCHAR(255),
    phone               VARCHAR(50),
    location_en         VARCHAR(200),
    location_fr         VARCHAR(200),
    location_ar         VARCHAR(200),
    availability_en     VARCHAR(200) DEFAULT 'Freelance / Full-time',
    availability_fr     VARCHAR(200) DEFAULT 'Freelance / Temps plein',
    availability_ar     VARCHAR(200) DEFAULT 'عمل حر / دوام كامل',
    -- Form field labels
    label_name_en       VARCHAR(80)  DEFAULT 'Your Name',
    label_name_fr       VARCHAR(80)  DEFAULT 'Votre nom',
    label_name_ar       VARCHAR(80)  DEFAULT 'اسمك',
    label_email_en      VARCHAR(80)  DEFAULT 'Your Email',
    label_email_fr      VARCHAR(80)  DEFAULT 'Votre e-mail',
    label_email_ar      VARCHAR(80)  DEFAULT 'بريدك الإلكتروني',
    label_subject_en    VARCHAR(80)  DEFAULT 'Subject',
    label_subject_fr    VARCHAR(80)  DEFAULT 'Sujet',
    label_subject_ar    VARCHAR(80)  DEFAULT 'الموضوع',
    label_message_en    VARCHAR(80)  DEFAULT 'Your Message',
    label_message_fr    VARCHAR(80)  DEFAULT 'Votre message',
    label_message_ar    VARCHAR(80)  DEFAULT 'رسالتك',
    label_send_en       VARCHAR(80)  DEFAULT 'Send Message',
    label_send_fr       VARCHAR(80)  DEFAULT 'Envoyer',
    label_send_ar       VARCHAR(80)  DEFAULT 'إرسال',
    -- "Interested in working together?" CTA banner (bottom of project detail)
    cta_banner_heading_en VARCHAR(200) DEFAULT 'Interested in working together?',
    cta_banner_heading_fr VARCHAR(200) DEFAULT 'Intéressé à travailler ensemble ?',
    cta_banner_heading_ar VARCHAR(200) DEFAULT 'مهتم بالعمل معاً؟',
    cta_banner_sub_en   VARCHAR(300) DEFAULT "Let's build something amazing together.",
    cta_banner_sub_fr   VARCHAR(300) DEFAULT 'Construisons quelque chose d\'incroyable ensemble.',
    cta_banner_sub_ar   VARCHAR(300) DEFAULT 'لنبني شيئًا رائعًا معًا.',
    cta_banner_btn_en   VARCHAR(80)  DEFAULT 'Contact Me →',
    cta_banner_btn_fr   VARCHAR(80)  DEFAULT 'Contactez-moi →',
    cta_banner_btn_ar   VARCHAR(80)  DEFAULT 'تواصل معي →',
    updated_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 25. CONTACT MESSAGES  (form submissions from visitors)
-- ============================================================
CREATE TABLE contact_messages (
    id           INT UNSIGNED NOT NULL AUTO_INCREMENT,
    sender_name  VARCHAR(200) NOT NULL,
    sender_email VARCHAR(255) NOT NULL,
    subject      VARCHAR(300),
    message      TEXT NOT NULL,
    is_read      TINYINT(1) NOT NULL DEFAULT 0,
    created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX idx_msg_read (is_read),
    INDEX idx_msg_date (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 26. NAV MENU ITEMS  (navbar labels, support i18n)
--     Home, About, Projects, Skills, Blogs, Contact
-- ============================================================
CREATE TABLE nav_items (
    id           TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    route_key    VARCHAR(50)  NOT NULL,            -- 'home','about','projects'…
    href         VARCHAR(200) NOT NULL,            -- '#home', '/projects'
    label_en     VARCHAR(80)  NOT NULL,
    label_fr     VARCHAR(80),
    label_ar     VARCHAR(80),
    icon_class   VARCHAR(100),
    sort_order   TINYINT UNSIGNED NOT NULL DEFAULT 0,
    is_active    TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    UNIQUE KEY uq_nav_route (route_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 27. ADMIN USERS  (CMS back-office login)
-- ============================================================
CREATE TABLE admin_users (
    id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name            VARCHAR(120) NOT NULL,
    email           VARCHAR(255) NOT NULL,
    password_hash   VARCHAR(255) NOT NULL,
    role            ENUM('superadmin','editor') NOT NULL DEFAULT 'editor',
    last_login_at   DATETIME,
    created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_admin_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- SEED — nav items
-- ============================================================
INSERT INTO nav_items (route_key, href, label_en, label_fr, label_ar, sort_order) VALUES
('home',     '#home',     'Home',     'Accueil',    'الرئيسية', 1),
('about',    '#about',    'About',    'À propos',   'عني',      2),
('projects', '/projects', 'Projects', 'Projets',    'المشاريع', 3),
('skills',   '#skills',   'Skills',   'Compétences','المهارات', 4),
('blogs',    '/blogs',    'Blogs',    'Articles',   'المقالات', 5),
('contact',  '#contact',  'Contact',  'Contact',    'التواصل',  6);

-- ============================================================
-- SEED — default stats counters
-- ============================================================
INSERT INTO stats (value, icon_class, label_en, label_fr, label_ar, sort_order) VALUES
('50+', 'icon-rocket',     'Projects Completed', 'Projets réalisés',  'مشاريع منجزة',     1),
('30+', 'icon-smile',      'Happy Clients',      'Clients satisfaits','عملاء سعداء',       2),
('3+',  'icon-award',      'Years Experience',   'Ans d\'expérience', 'سنوات خبرة',        3),
('100%','icon-code',       'Commitment',         'Engagement',        'الالتزام',          4);
