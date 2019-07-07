{
    a = builtins.attrNames;

    # Short for "what"
    w = pkg: pkg.meta.description;

    # Short for "URL"
    u = pkg: pkg.meta.homepage;
}
