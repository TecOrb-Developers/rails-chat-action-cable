# Here we add the the name of the stage ("base")
FROM ruby:3.0.1-slim

# Common dependencies
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    curl \
    less \
    git \
    default-libmysqlclient-dev \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# Install NodeJS and Yarn
ARG NODE_MAJOR=16
RUN curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    nodejs \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && truncate -s 0 /var/log/*log
RUN npm install -g yarn

# Create a directory for the app code, bundler, and supporting directories
RUN mkdir -p /app
RUN mkdir -p /bundle

# Set environment variables
ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3 \
  BUNDLE_APP_CONFIG=/bundle \
  BUNDLE_PATH=/bundle \
  GEM_HOME=/bundle \
  RAILS_ENV=development

# Upgrade RubyGems and install the latest Bundler version
RUN gem update --system && \
    gem install bundler

# Install development dependencies from Aptfile.dev
COPY Aptfile.dev /tmp/Aptfile.dev
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    $(grep -Ev '^\s*#' /tmp/Aptfile.dev | xargs) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log

WORKDIR /app

# Copy dependency files
COPY Gemfile Gemfile.lock ./

# TODO: Stop forcing platform to Ruby once we're at Ruby >= 2.6
# We do this to be able to install Nokogiri because our image doesn't have
# glibc 2.29 and we cannot install glibc 2.29 on our image.
# With this approach, Nokogiri is installed without C extensions and the performance
# is slower.

# Install Ruby gems and configure Bundler
RUN mkdir -p $BUNDLE_PATH \
  # && bundle config --local deployment 'true' \
  && bundle config --local path "${BUNDLE_PATH}" \
  && bundle config --local with 'development test' \
  && bundle config --local clean 'true' \
  && bundle config --local force_ruby_platform 'true' \
  && bundle config --local no-cache 'false' \
  && bundle install --jobs=${BUNDLE_JOBS} \
  && rm -rf /bundle/cache/*

# Copy code
COPY . .

# Precompile assets
# NOTE: The command may require adding some environment variables (e.g., SECRET_KEY_BASE) if you're not using
# credentials.
# RUN bundle exec rails assets:precompile

# Expose port 3000 to the host
EXPOSE 3000

# CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
CMD ["/usr/bin/bash"]
