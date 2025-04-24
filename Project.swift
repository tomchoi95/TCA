import ProjectDescription

let project = Project(
    name: "TCADemo",
    packages: [
        .remote(url: "https://github.com/pointfreeco/swift-composable-architecture", requirement: .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(
            name: "TCADemo",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.TCADemo",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["TCADemo/Sources/**"],
            resources: ["TCADemo/Resources/**"],
            dependencies: [
                .package(product: "ComposableArchitecture")
            ]
        ),
        .target(
            name: "TCADemoTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.TCADemoTests",
            infoPlist: .default,
            sources: ["TCADemo/Tests/**"],
            resources: [],
            dependencies: [.target(name: "TCADemo")]
        ),
    ]
)
