{
  "targets": [
    {
      "target_name": "ashot",
      "sources": [
        "src/init.cc",
        "src/screenshot.mm"
      ],
      "include_dirs": [
        "<!(node -e \"require('nan')\")",
      ]

      # ,
      # "link_settings": {
      #   "libraries": [
      #     "-framework Carbon",
      #     "-framework CoreFoundation"
      #   ]
      # }
    }
  ]
}
